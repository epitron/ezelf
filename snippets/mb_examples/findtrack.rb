require 'rubygems'
#!/usr/bin/ruby 

require 'musicbrainz'

# allocate a new MusicBrainz client
mb = MusicBrainz::Client.new

mb.max_items = 10

# handle environment variables
mb.server = server if server = ENV['MB_SERVER']
mb.debug = true if ENV['MB_DEBUG']
mb.depth = depth.to_i if depth = ENV['MB_DEPTH']


unless ARGV.size
  $stderr.puts 'Missing query string.'
  exit -1
end

query_string = ARGV[0]

# search for track
puts 'Query: ' << query_string
if mb.query MusicBrainz::Query::FindTrackByName, query_string
  num_tracks = mb.result(MusicBrainz::Query::GetNumTracks).to_i

  if num_tracks < 1
    puts 'No tracks found.'
    exit 0
  end

  puts "Found #{num_tracks} tracks."

  1.upto(num_tracks) { |i|
    # back up to the top context
    mb.select MusicBrainz::Query::Rewind

    # select the Ith track
    mb.select MusicBrainz::Query::SelectTrack, i

    # extract the track name
    track_name = mb.result MusicBrainz::Query::TrackGetTrackName
    puts 'Track: ' << track_name

    # extract the artist name
    artist_name = mb.result MusicBrainz::Query::TrackGetArtistId
    puts 'Artist: ' << mb.id_from_url(artist_name)

    # extract the artist id
    artist_id = mb.result MusicBrainz::Query::TrackGetArtistId
    puts 'ArtistId: ' << mb.id_from_url(artist_id)

    puts 
  }
else
  $stderr.puts 'Error: ' << mb.error
end
