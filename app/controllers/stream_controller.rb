require 'sha1'

=begin

GET /files/Unknown_-_Ungawa.mp3 HTTP/1.1
Host: chris.ill-logic.com
User-Agent: WinampMPEG/5.35
Accept: */*
Range: bytes=340593-
Connection: close

HTTP/1.1 206 Partial Content
Date: Sun, 10 Jun 2007 13:50:18 GMT
Server: Apache/2.0.55 (Ubuntu) mod_fastcgi/2.4.2 mod_python/3.1.4 Python/2.4.3 PHP/4.4.2-1build1 mod_scgi/1.9 mod_webkit2/0.5
Last-Modified: Sat, 28 Oct 2006 20:32:25 GMT
ETag: "1d7474-ca06c-ef398840"
Accept-Ranges: bytes
Content-Length: 486907
Content-Range: bytes 340593-827499/827500
Connection: close
Content-Type: audio/mpeg

=end

class StreamController < ApplicationController

    session :off, :only => %w[track]

    layout false

    def session_from_params
        if key = params[:key]
            key
        end
    end

=begin
    def stream_file(path, options)
      raise MissingFile, "Cannot read file #{path}" unless File.file?(path) and File.readable?(path)

      options[:length]   ||= File.size(path)
      options[:filename] ||= File.basename(path)
      send_file_headers! options

      headers["Last-Modified"] = File.mtime(path).rfc2822 # "Sun, 26 Feb 2006 21:18:23 GMT"
      headers["Accept-Ranges"] = "bytes"
      headers["Content-Length"] = options[:length]
      headers["Content-Type"] = "audio/mpeg"
      headers["ETag"] = SHA1.new(path).to_s
      #headers["Connection"] = "close"
      #headers["Cache-Control"] = "public"

      @performed_render = false
      #pp request.env

      print "opening #{path.inspect}..."
      file = File.open(path, 'rb')
      puts "done!"

      if request.env["HTTP_RANGE"] =~ /bytes=(\d+)-(.*)$/ || request.env["HTTP_CONTENT_RANGE"] =~ /bytes (\d+)-(.*)$/
          file.seek($1.to_i)
          headers["Content-Range"] = "bytes #{file.pos}-#{options[:length] - 1}/#{options[:length]}"
          puts "Sending range: #{headers["Content-Range"]}"
      end

      if options[:stream]
          render :status => options[:status], :text => Proc.new { |response, output|
              sent = 0; last_size = 0
              logger.info "Streaming file #{path}" unless logger.nil?
              len = options[:buffer_size] || 4096
              while buf = file.read(len)
                  output.write(buf)
                  sent += len
                  output.flush
                  print ("\b"*last_size)+"#{sent}"
                  last_size = sent.to_s.size
              end
          }
      else
          logger.info "Sending file #{path}" unless logger.nil?
          render :status => options[:status], :text => file.read
      end

      #pp response.headers
    end
=end

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

    def render_playlist
      headers["Content-Type"] = "audio/x-mpegurl; charset=utf-8"
      output = []
      output << "#EXTM3U"
      for track in @tracks
        output << "#EXTINF:#{track.length.to_i},#{track.artist.name} - #{track.album.name} - #{track.number}. #{track.title}"
        output << "#{url_for :action=>"track", :id=>track.id}.mp3"
      end
      
      render :text => output.join("\n")
    end

    #after_filter :playlist_filter, :only=>[:album, :artist, :shuffle, :folder]

    def album
      @album = Album.find(params[:id])
      @tracks = @album.sorted_tracks
      render_playlist
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
        output << url_for(:action=>"uploaded_file", :user=>user.id, :relative_path=>relative_path, :filename=>filename)
      end
      
      headers["Content-Type"] = "audio/x-mpegurl; charset=utf-8"
      render :text => output.join("\n")
    end
    
    def uploaded_file
      user              = User.find params[:user]
      relative_path     = params[:relative_path]
      filename          = params[:filename]
      relative_filepath = File.join(relative_path, filename)
      base              = user.upload_dir
      raise "Bad mojo!" unless safe_subdir?(base, relative_filepath)
      
      fullpath = File.join(base, relative_filepath)
      puts "sending uploaded_file: #{fullpath.inspect}"
      xsendfile fullpath, :type => 'audio/mpeg'
    end

end
