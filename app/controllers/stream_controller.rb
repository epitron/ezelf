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

        file = File.open(path, 'rb')
        if request.env["HTTP_RANGE"] =~ /bytes=(\d+)-(.*)$/ || request.env["HTTP_CONTENT_RANGE"] =~ /bytes (\d+)-(.*)$/
            file.seek($1.to_i)
            headers["Content-Range"] = "bytes #{file.pos}-#{options[:length] - 1}/#{options[:length]}"
            puts "Sending range: #{headers["Content-Range"]}"
        end

        if options[:stream]
            render :status => options[:status], :text => Proc.new { |response, output|
                logger.info "Streaming file #{path}" unless logger.nil?
                len = options[:buffer_size] || 4096
                while buf = file.read(len)
                    output.write(buf)
                end
            }
        else
            logger.info "Sending file #{path}" unless logger.nil?
            render :status => options[:status], :text => file.read
        end

        #pp response.headers
    end

    def xsendfile(path, options)
        headers["Content-Transfer-Encoding"] = "binary"
        headers["Content-Type"] = "application/force-download"
        #headers["Content-Type"] = options[:type] if options[:type]

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
        #send_file track.file, :type => 'audio/mpeg', :stream => true, :buffer_size => 4096, :disposition => 'inline'
        stream_file track.fullpath, :type => 'audio/mpeg', :stream => true, :buffer_size => 4096, :disposition => 'inline'
        #xsendfile track.file, :type => 'audio/mpeg'
    end



    ### Playlists

    def render_playlist
        headers["Content-Type"] = "audio/x-mpegurl; charset=utf-8"
        render "stream/playlist"
    end

    #after_filter :playlist_filter, :only=>[:album, :artist, :shuffle, :folder]

    def album
        @album = Album.find(params[:id])
        @tracks = @album.tracks
        render_playlist
    end

    def artist
        @artist = Artist.find(params[:id])
        @tracks = @artist.albums.map(&:tracks).flatten
        render_playlist
    end

    def shuffle
        num = params[:id].to_i
        num = 400 if num > 400
        @tracks = Track.find_by_sql( ["SELECT * FROM tracks ORDER BY rand() LIMIT ?", num])
        render_playlist
    end

    def folder
        @tracks = Track.find :all, :conditions=>{:relative_path => params[:relative_path]}, :order=>"relative_path, filename"
        render_playlist
    end

end
