# == Schema Information
# Schema version: 10
#
# Table name: tracks
#
#  id            :integer(11)   not null, primary key
#  title         :string(255)   
#  album_id      :integer(11)   
#  number        :integer(11)   
#  disc          :integer(11)   
#  artist_id     :integer(11)   
#  relative_path :string(255)   
#  filename      :string(255)   
#  source_id     :integer(11)   
#

# http://id3lib-ruby.rubyforge.org/doc/index.html
# http://ruby-mp3info.rubyforge.org/

class Track < ActiveRecord::Base

    belongs_to :album
    belongs_to :artist
    belongs_to :source

    def artist
        @attributes[:artist] || album.artist
    end

    def dirs
        @cached_dirs ||= relative_path.split '/'
    end

    def seconds
        -1
    end

    def fullpath
        File.join( source.uri, relative_path, filename )
    end

    def self.all
        Track.find_by_sql("SELECT * FROM artists,albums,tracks WHERE tracks.album_id = albums.id AND albums.artist_id = artists.id ORDER BY artists.name,albums.name,tracks.number")
    end

    def self.add_file( source, path_and_filename )
        # TODO: bug -- albums with > 1 artist get associated with the last artist.
        #       |_ to fix, put all Tag's in an array keyed by album, and mark ones with > 1 artist as "various".
        #       |_ support "Album Artist" tag

        root = source.uri
        fullpath = File.join( root, path_and_filename )
        relative_path, filename = File.split(path_and_filename)

		mp3 = Mp3Info::new(fullpath)
        tag = mp3.tag
        pp tag

        # find/create track, album, and artist

        track   = Track.find_or_create_by_source_id_and_relative_path_and_filename(source.id, relative_path, filename)
        album   = Album.find_or_create_by_name(tag.album)
        artist  = Artist.find_or_create_by_name(tag.artist)

        # set the albums and artists
        if false #tag.album_artist and tag.album_artist != tag.artist   # this is probably a compilation album...
            # find/create a new artist for the album as a whole
            album_artist = Artist.find_or_create_by_name(tag.album_artist)
            # link album
            album_artist.albums << album
            # link track to artist and album
            artist.compilation_tracks << track
            album.tracks << track
            album.compilation = true
        else
            album.tracks  << track  # track goes in album
            artist.albums << album  # album goes in artist
        end

        track.title         = tag.title
        track.number        = tag.tracknum
        track.relative_path = source.properly_encode_path(relative_path)
        track.filename      = source.properly_encode_path(filename)
        track.bitrate		= mp3.bitrate
        track.length		= mp3.length
        track.vbr			= mp3.vbr

        track.save
        album.save
        artist.save

        return track
    end

end
