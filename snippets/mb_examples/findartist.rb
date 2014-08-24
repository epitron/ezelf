#!/usr/bin/ruby

require 'rubygems'
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

# search for artist
puts 'Query: ' << query_string
if mb.query MusicBrainz::Query::FindArtistByName, query_string
  $stderr.puts 'debug: get result'
  num_artists = mb.result(MusicBrainz::Query::GetNumArtists).to_i

  if num_artists < 1
    puts 'No artists found.'
    exit 0
  end

  puts "Found #{num_artists} artists."

  1.upto(num_artists) { |i|
    # back up to the top context
    mb.select MusicBrainz::Query::Rewind

    # select the Ith artist
    mb.select MusicBrainz::Query::SelectArtist, i

    # extract the artist name
    artist_name = mb.result MusicBrainz::Query::ArtistGetArtistName
    puts 'Artist: ' << artist_name

    # extract the artist id
    artist_id = mb.result MusicBrainz::Query::ArtistGetArtistId
    puts 'ArtistId: ' << mb.id_from_url(artist_id)

    puts
  }
else
  $stderr.puts 'Error: ' << mb.error
end
