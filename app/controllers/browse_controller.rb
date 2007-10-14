class BrowseController < ApplicationController
    layout "default"

    def index
        @random_albums = Album.random(10)
        elf = random_elf
        @elf_image = "/elves/#{elf}"
        @elf_title = elf.gsub /\.[^\.]+$/, ''
    end

    def artists
        @artists = Artist.find(:all, :order=>"artists.name", :include=>:albums).select{|a| a.albums.size > 0}
    end

    def tracks
        @tracks = Track.all
    end

    def uploads
      # Collect all uploads by user. Results in:
      #   @alluploads[user] = { 'Album Name'=>['1.mp3', '2.mp3', ...], ... }

      @tree = {}
      for user in User.find :all
        if user.upload_dir
          files = user.tree_of_uploaded_files.to_a.sort
          @tree[user] = files if files.any?
        end
      end
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
      @artist = Artist.find( params[:id], :include=>{:albums=>:tracks} )
      #fetch_from_html_id( :artist, html_id )
      html_id = @artist.html_id
      expand_id = "#{html_id}_albums"
      render :update do |page|
        page.replace_html expand_id, :partial => 'albums'
        page[expand_id].loaded = 1
        page.show expand_id
        #visual_effect :slide_down, expand_id
        #visual_effect :toggle_slide, expand_id
        page.visual_effect :highlight, html_id
      end
    end

    def more_random_albums
      @random_albums = Album.random(10)
      render :update do |page|
        page.replace_html "randomalbums", :partial => 'random_albums'
      end
    end

    def random_elf
        elves = Dir["public/elves/*"]
        File.basename elves[rand(elves.size)]
    end

end
