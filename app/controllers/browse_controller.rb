class BrowseController < ApplicationController
    layout "default"

    def index
        redirect_to :action=>"artists"
    end

    def artists
        @artists = Artist.find(:all, :include=>{ :albums => :tracks }, :order=>"artists.name, tracks.number").select{|artist| artist.albums.any?}
    end

    def tracks
        @tracks = Track.all
    end

    def files
        alltracks = Track.find :all, :order=>"relative_path, filename"
        @tree = alltracks.group_by{|o| o.relative_path}.to_a.sort_by{|k,v| k}
    end

    def index
    end

    def session_key
        render :text=>session.inspect.gsub('<','&lt;').gsub('>','&gt;')+"<pre>#{session.methods.inspect}</pre>"
    end

    def requestinfo
    end


    def index
    end

end
