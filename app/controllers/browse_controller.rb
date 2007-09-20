class BrowseController < ApplicationController
    layout "default"

    def index
        @random_albums = Album.find :all, :limit=>10, :order=>"RAND()"
        elf = random_elf
        @elf_image = "/elves/#{elf}"
        @elf_title = elf.gsub /\.[^\.]+$/, ''
        #redirect_to :action=>"artists"
    end

    def artists
        @artists = Artist.find(:all, :include=>:albums, :order=>"artists.name").select{|artist| artist.albums.any?}
    end

    def tracks
        @tracks = Track.all
    end

    def files
        @alltracks = Track.find :all, :order=>"relative_path, filename"
        @tree = @alltracks.group_by{|o| o.relative_path}.to_a.sort_by{|k,v| k}
    end

    def search
        @query = params[:query]
        @alltracks = Track.find(
          :all, 
          :conditions=>(["relative_path like ? or filename like ?"] + ["%#{@query}%"]*2), 
          :order=>"relative_path, filename"
        )
        @tree = @alltracks.group_by{|o| o.relative_path}.to_a.sort_by{|k,v| k}
        render :action=>"files"
    end

    def session_key
        render :text=>session.inspect.gsub('<','&lt;').gsub('>','&gt;')+"<pre>#{session.methods.inspect}</pre>"
    end

    def requestinfo
    end

    def fetch_from_html_id(modelname, html_id)
      if html_id =~ /^([\w_]+)_(\d+)$/
        assert modelname.to_s == $1
        modelclass = modelname.classify.constantize
        return modelclass.find($2.to_i)
      else
        raise "Invalid html_id: #{html_id}"
      end
    end    

    def expand_artist
      #html_id = params[:id]
      @artist = Artist.find params[:id], :include=>{:albums=>:tracks}
      #fetch_from_html_id( :artist, html_id )
      render :update do |page|
        html_id = @artist.html_id
        #page.visual_effect :fade, html_id
        page.replace_html html_id, :partial => 'albums'
        #page.visual_effect :appear, html_id
      end
    end

    def random_elf
        elves = Dir["public/elves/*"]
        File.basename elves[rand(elves.size)]
    end

end
