
# http://id3lib-ruby.rubyforge.org/doc/index.html
require 'id3lib'


class Track < ActiveRecord::Base
	
	belongs_to :album
	
	def artist
		album.artist
	end
	
	def self.all
		Track.find_by_sql("SELECT * FROM artists,albums,tracks WHERE tracks.album_id = albums.id AND albums.artist_id = artists.id ORDER BY artists.name,albums.name,tracks.number")
	end
		
	def self.add_file( file )
		tag = ID3Lib::Tag.new(file)
		
		artist 	= Artist.find_or_create_by_name(tag.artist)
		album 	= Album.find_or_create_by_name(tag.album)
		track 	= Track.find_or_create_by_file(file)

		track.title = tag.title
		track.number = tag.track
		
		album.tracks 	<< track
		artist.albums 	<< album
		
		track.save
		album.save
		artist.save
		
		return track
	end
		
end
