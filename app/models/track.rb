# http://id3lib-ruby.rubyforge.org/doc/index.html

class Track < ActiveRecord::Base
	
	belongs_to :album
	belongs_to :artist
	
	def artist
		@attributes[:artist] || album.artist
	end
	
	def dirs
		@dirs ||= relative_path.split('/')[0..-2]
	end
	
	def fullpath
		File.join( root, relative_path, filename )
	end
	
	def self.all
		Track.find_by_sql("SELECT * FROM artists,albums,tracks WHERE tracks.album_id = albums.id AND albums.artist_id = artists.id ORDER BY artists.name,albums.name,tracks.number")
	end
		
	def self.add_file( root, path_and_filename )
		# TODO: bug -- albums with > 1 artist get associated with the last artist. 
		#       |_ to fix, put all Tag's in an array keyed by album, and mark ones with > 1 artist as "various".
		#       |_ support "Album Artist" tag

		fullpath = File.join( root, path_and_filename )
		relative_path, filename = File.split(path_and_filename)

		tag = ID3Lib::Tag.new(fullpath)
		
		track 	= Track.find_or_create_by_root_and_relative_path_and_filename(root, relative_path, filename)
		artist 	= Artist.find_or_create_by_name(tag.artist)
		album   = Album.find_or_create_by_name(tag.album)

		if tag.album_artist
			album_artist = Artist.find_or_create_by_name(tag.album_artist)
			album_artist.albums << album
			artist.tracks << track
			album.compilation = true
		else
			album.tracks 	<< track
			artist.albums 	<< album
		end
		
		track.title 		= tag.title
		track.number 		= tag.track.to_i
		track.root 			= root
		track.relative_path = relative_path
		track.filename 		= filename
		
		track.save
		album.save
		artist.save
		
		return track
	end
		
end
