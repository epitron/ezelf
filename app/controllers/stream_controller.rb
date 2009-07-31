require 'sha1'

class StreamController < ApplicationController

  Mime::Type.register "application/zip",      :zip
  Mime::Type.register "audio/x-mpegurl",      :m3u
  Mime::Type.register "audio/x-scpls",        :pls
  Mime::Type.register "application/xspf+xml", :xspf

  session :off, :only => %w[track]

  include StreamHelper

  layout false

  def session_from_params
      if key = params[:key]
          key
      end
  end


  ####################################################################
  ## Utility Stuff
  ####################################################################

  def xsendfile(path, options)
    headers["Content-Transfer-Encoding"] = "binary"
    headers["Content-Type"] = options[:type] || "application/force-download"

    headers["X-Sendfile"] = path
    headers["Content-Disposition"] = "attachment; file=\"#{File.basename path}\""
    #headers["Content-Length"] = File.size(path)

    # TODO: What does @performed_render change?
    #@performed_render = false
    render :nothing => true
  end

  def track
    track = Track.find(params[:id])
    #pp request.env
    #"HTTP_RANGE"=>"bytes=878672-",
    #send_file track.fullpath, :type => 'audio/mpeg', :stream => true, :buffer_size => 4096, :disposition => 'inline'
    #stream_file track.fullpath, :type => 'audio/mpeg', :stream => true, :buffer_size => 4096, :disposition => 'inline'
    xsendfile track.fullpath, :type => 'audio/mpeg'
  end


  ### Playlists

  def render_m3u_playlist(tracks)
    #headers["Content-Type"] = "audio/x-mpegurl; charset=utf-8"
    output = []
    output << "#EXTM3U"
    for track in tracks
      output << "#EXTINF:#{track.length.to_i},#{track.playlist_title}"
      output << track_url(track)
    end
    output << ""
    
    render :text => output.join("\n")
  end

  def render_pls_playlist(tracks)
    #headers["Content-Type"] = "audio/x-scpls; charset=utf-8"
    output = []
    output << "[playlist]"
    output << "NumberOfEntries=#{tracks.size}"
    output << ""

    tracks.each_with_index do |track, i|
      n       = i+1
      url     = track_url(track)
      title   = track.playlist_title
      length  = track.length.to_i

      output << "File#{n}=#{url}"
      output << "Title#{n}=#{title}"
      output << "Length#{n}=#{length}"
      output << ""
    end

    output << "Version=2"
    output << ""

    render :text => output.join("\n")
  end

  def render_xspf_playlist(tracks)
    #<?xml version="1.0" encoding="UTF-8"?>
    #<playlist version="1" xmlns="http://xspf.org/ns/0/">
    #    <trackList>
    #        <track>
    #            <location>http://example.com/song_1.mp3</location>
    #
    #            <!-- artist or band name -->
    #            <creator>Led Zeppelin</creator>
    #
    #            <!-- album title -->
    #            <album>Houses of the Holy</album>
    #
    #            <!-- name of the song -->
    #            <title>No Quarter</title>
    #
    #            <!-- comment on the song -->
    #            <annotation>I love this song</annotation>
    #
    #            <!-- song length, in milliseconds -->
    #            <duration>271066</duration>
    #
    #            <!-- album art -->
    #            <image>http://images.amazon.com/images/P/B000002J0B.01.MZZZZZZZ.jpg</image>
    #
    #            <!-- if this is a deep link, URL of the original web page -->
    #            <info>http://example.com</info>
    #
    #        </track>
    #    </trackList>
    #</playlist>

    @tracks = tracks
    render :partial=>"xspf_playlist.xml"
  end

  ## Zipfile

  def render_zipfile(tracks)
    paths = []
    tracks.each do |track|
      begin
        #dest = File.join(track.relative_path, track.filename)
        #src = track.fullpath
        paths << track.fullpath
      rescue ActiveRecord::RecordNotFound
        puts "Couldn't find track #{track.id}"
      end
    end
    #xsendfile tempzip.path, :type => 'application/zip'

    headers["Content-Type"] = 'application/zip'
    zip = StreamedZip.new(paths)
    render :text => proc { |response, output|
      zip.stream do |chunk|
        output.write(chunk)
        #output.flush
      end
    }

  end

  def old_render_zipfile(tracks)
    puts "Removing old zips:"
    Dir['/tmp/elfzip*'].each{|p| puts "  - #{p}"; File.unlink p}

    tempzip = Tempfile.new("elfzip")
    tempzip.close!

    puts "Creating zip: #{tempzip.path}"
    Zip::ZipFile.open(tempzip.path, Zip::ZipFile::CREATE) do |zf|
      for track in tracks
       begin
        dest = File.join(track.relative_path, track.filename)
        src = track.fullpath
        puts "  * #{dest}"
        zf.add( dest, src )
       rescue ActiveRecord::RecordNotFound
        puts "Couldn't find track #{track.id}"
       end
      end
    end
    File.chmod 0644, tempzip.path, true
    xsendfile tempzip.path, :type => 'application/zip'
  end

  #after_filter :playlist_filter, :only=>[:album, :artist, :shuffle, :folder]

  def album
    @album = Album.find(params[:id])
    @tracks = @album.sorted_tracks
    respond_to do |format|
      format.zip    { render_zipfile        @tracks }
      format.m3u    { render_m3u_playlist   @tracks }
      format.pls    { render_pls_playlist   @tracks }
      format.xspf   { render_xspf_playlist  @tracks }
    end
  end

  def artist
    @artist = Artist.find(params[:id])
    @tracks = @artist.albums.map(&:sorted_tracks).flatten
    render_playlist
  end

  def shuffle
    num = params[:id].blank? ? 150 : params[:id].to_i
    num = 400 if num > 400
    @tracks = Track.find_by_sql( ["SELECT * FROM tracks ORDER BY rand() LIMIT ?", num])
    render_playlist
  end

  def folder
    @tracks = Track.find :all, :conditions=>{:relative_path => params[:relative_path]}, :order=>"relative_path, filename"
    render_playlist
  end

  def safe_subdir?(base, sub)
    path = File.join(base, sub)
    expanded = File.expand_path(path)
    # it's a subdir if "base" is a prefix of "expanded"
    return expanded.index(base) == 0
  end

  def uploaded_dir
    user = User.find params[:user]
    relative_path = params[:relative_path]
    #base = user.upload_dir
    #raise "Bad mojo!" unless safe_subdir?(base, relative_path)
    tree = user.tree_of_uploaded_files
    raise "Bad mojo!" unless tree[relative_path]

    output = []
    output << "#EXTM3U"
    #for path in Dir["#{base}/#{relative_path}/**/*.mp3"].sort
    for filename in tree[relative_path].sort
      output << "#EXTINF:-1,#{relative_path}/#{filename}"
      #output << url_for(:action=>"uploaded_file", :user=>user.id, :relative_path=>relative_path, :filename=>filename)
      output << url_for(:action=>"uploaded_file", :username=>user.name, :relative_filepath=>File.join(relative_path, filename))
    end

    headers["Content-Type"] = "audio/x-mpegurl; charset=utf-8"
    render :text => output.join("\n")
  end

  def uploaded_file
    user              = User.find_by_name params[:username]
    relative_filepath = params[:relative_filepath] #File.join(relative_path, filename)
    base              = user.upload_dir
    raise "Bad mojo!" unless safe_subdir?(base, relative_filepath)

    fullpath = File.join(base, relative_filepath)
    puts "sending uploaded_file: #{fullpath.inspect}"
    xsendfile fullpath, :type => 'audio/mpeg'
  end

end
