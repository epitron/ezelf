#!/usr/bin/ruby 

require 'musicbrainz'

# allocate a new MusicBrainz client
mb = MusicBrainz::Client.new
mb.depth = 2

# handle environment variables
mb.server = server if server = ENV['MB_SERVER']
mb.debug = true if ENV['MB_DEBUG']
mb.depth = depth.to_i if depth = ENV['MB_DEPTH']


unless ARGV.size > 0
  $stderr.puts 'Missing query string.'
  exit -1
end

query_string = ARGV[0]

# search for artist
puts 'Query: ' << query_string
if mb.query MusicBrainz::Query::GetArtistById, query_string
  # select the first artist
  mb.select MusicBrainz::Query::SelectArtist, 1

  # pull back the artist id to see if we got the artist
  unless artist_id = mb.result(MusicBrainz::Query::ArtistGetArtistId)
    $stderr.puts 'Artist not found.'
    exit 0
  end

  id_str = mb.id_from_url artist_id
  puts 'ArtistId: ' << id_str

  # extract the artist name
  artist_name = mb.result MusicBrainz::Query::ArtistGetArtistName
  puts 'ArtistName: ' << artist_name if artist_name
  
  # extract the artist sort name
  sort_name = mb.result MusicBrainz::Query::ArtistGetArtistSortName
  puts 'SortName: ' << sort_name if sort_name
else
  $stderr.puts 'Error: ' << mb.error
end
