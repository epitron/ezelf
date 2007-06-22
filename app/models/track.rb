# http://id3lib-ruby.rubyforge.org/doc/index.html

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
        File.join( root, relative_path, filename )
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

        tag = ID3Lib::Tag.new(fullpath)

        # find/create track, album, and artist

        track   = Track.find_or_create_by_source_id_and_relative_path_and_filename(source.id, relative_path, filename)
        album   = Album.find_or_create_by_name(tag.album)
        artist  = Artist.find_or_create_by_name(tag.artist)

        # set the albums and artists
        if tag.album_artist and tag.album_artist != tag.artist   # this is probably a compilation album...
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
        track.number        = tag.track.to_i
        track.relative_path = relative_path
        track.filename      = filename

        track.save
        album.save
        artist.save

        return track
    end

end
