#!/usr/bin/ruby 

require 'musicbrainz'

# allocate a new MusicBrainz client
mb = MusicBrainz::Client.new

mb.max_items = 10

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
if mb.query MusicBrainz::Query::FindAlbumByName, query_string
  num_albums = mb.result(MusicBrainz::Query::GetNumAlbums).to_i

  if num_albums < 1
    puts 'No albums found.'
    exit 0
  end

  puts "Found #{num_albums} albums."

  1.upto(num_albums) { |i|
    # back up to the top context
    mb.select MusicBrainz::Query::Rewind

    # select the Ith album
    mb.select MusicBrainz::Query::SelectAlbum, i

    # extract the album name
    album_name = mb.result MusicBrainz::Query::AlbumGetAlbumName
    puts 'Album: ' << album_name

    # extract the album name
    album_id = mb.result MusicBrainz::Query::AlbumGetAlbumId
    puts 'AlbumId: ' << mb.id_from_url(album_id)

    # extract the album name
    artist_id = mb.result MusicBrainz::Query::AlbumGetAlbumArtistId
    puts 'ArtistId: ' << mb.id_from_url(artist_id)

    puts 
  }
else
  $stderr.puts 'Error: ' << mb.error
end
