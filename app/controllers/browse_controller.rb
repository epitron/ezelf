class BrowseController < ApplicationController
	def index
		redirect_to :action=>"artists"
	end

	def artists
		@artists = Artist.find(:all, :include=>[:albums, :tracks]).select{|artist| artist.albums.any?}
	end
	
	def tracks
		@tracks = Track.all
	end
	
	
end
