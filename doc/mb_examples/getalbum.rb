#!/usr/bin/ruby 

require 'musicbrainz'

# allocate a new MusicBrainz client
mb = MusicBrainz::Client.new
mb.depth = 4

# handle environment variables
mb.server = server if server = ENV['MB_SERVER']
mb.debug = true if ENV['MB_DEBUG']
mb.depth = depth.to_i if depth = ENV['MB_DEPTH']


unless ARGV.size > 0
  $stderr.puts 'Missing query string.'
  exit -1
end

query_string = ARGV[0]

# search for album
puts 'Query: ' << query_string
if mb.query MusicBrainz::Query::GetAlbumById, query_string
  # select the first album
  mb.select MusicBrainz::Query::SelectAlbum, 1

  # pull back the album id to see if we got the album
  unless album_id = mb.result(MusicBrainz::Query::AlbumGetAlbumId)
    $stderr.puts 'Album not found.'
    exit 0
  end

  id_str = mb.id_from_url album_id
  puts 'AlbumId: ' << id_str

  # extract the album name
  album_name = mb.result MusicBrainz::Query::AlbumGetAlbumName
  puts 'Album: ' << album_name

  # extract the number of tracks
  num_tracks = mb.result(MusicBrainz::Query::AlbumGetNumTracks).to_i
  puts 'Number of Tracks: ' << num_tracks.to_s

  # check to see if there's more than one artist for this album
  multi_artist = false
  first_artist_id = nil
  1.upto(num_tracks) { |i|
    artist_id = mb.result MusicBrainz::Query::AlbumGetArtistId, i
    first_artist_id = artist_id if i == 1
    multi_artist = true if first_artist_id != artist_id
  }

  unless multi_artist
    # extract the artist name from the album
    artist_name = mb.result MusicBrainz::Query::AlbumGetArtistName, 1 
    puts 'Album Artist: ' << artist_name

    # extract the artist id from the album
    if artist_id = mb.result(MusicBrainz::Query::AlbumGetArtistId, 1)
      id_str = mb.id_from_url artist_id
      puts 'ArtistId: ' << id_str
    end
  end

  puts

  1.upto(num_tracks) { |i|
    # extract track name from album
    track_name = mb.result(MusicBrainz::Query::AlbumGetTrackName, i)
    break unless track_name
    puts 'Track: ' << track_name

    if track_id = mb.result(MusicBrainz::Query::AlbumGetTrackId, i)
      puts 'TrackId: ' << mb.id_from_url(track_id)

      track_num = mb.ordinal MusicBrainz::Query::AlbumGetTrackList, track_id
      puts 'TrackNum: ' << track_num.to_s if track_num > 0 && track_num < 100
    end

    # if it's a multi-artist album, print out the artist for each track
    if multi_artist
      # extract artist name from this track
      puts 'TrackArtist: ' << artist_name if
        artist_name = mb.result(MusicBrainz::Query::AlbumGetArtistName, i)

      # extract the artist id from this track
      puts 'TrackArtistId: ' << mb.id_From_url(artist_id) if
        artist_id = mb.result(MusicBrainz::Query::AlbumGetArtistId, i)
    end

    puts
  }
else
  $stderr.puts 'Error: ' << mb.error
end
