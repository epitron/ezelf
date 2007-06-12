class Artist < ActiveRecord::Base
	has_many :albums
	has_many :album_tracks, :through=>:albums, :class_name=>"Track"
	has_many :compilation_tracks, :class_name=>"Track"
	
	def tracks
		album_tracks + compilation_tracks
	end
end
