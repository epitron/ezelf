require 'rubygems'
#!/usr/bin/ruby 

require 'musicbrainz'

# allocate a new MusicBrainz client
mb = MusicBrainz::Client.new
mb.depth = 2

# handle environment variables
mb.server = server if server = ENV['MB_SERVER']
mb.debug = true if ENV['MB_DEBUG']
mb.depth = depth.to_i if depth = ENV['MB_DEPTH']


unless ARGV.size > 1
  $stderr.puts 'Missing query strings.'
  exit -1
end

query = [ARGV[0], ARGV[1]]

# search for track
puts "Queries: #{query[0]}, #{query[1]}"
if mb.query(MusicBrainz::Query::QuickTrackInfoFromTrackId, *query)
  # extract artist name from track
  if artist = mb.result(MusicBrainz::Query::QuickGetArtistName)
    puts 'Artist: ' << artist
  end

  # extract album name from track
  if album = mb.result(MusicBrainz::Query::QuickGetAlbumName)
    puts 'Album: ' << album
  end

  # extract track name
  if track = mb.result(MusicBrainz::Query::QuickGetTrackName)
    puts 'Track: ' << track
  end

  # extract track name
  track_num = mb.result(MusicBrainz::Query::TrackGetTrackNum).to_i
  if track_num > 0 && track_num < 100
    puts 'TrackNum: ' << track_num.to_s
  end
else
  $stderr.puts 'Error: ' << mb.error
end
