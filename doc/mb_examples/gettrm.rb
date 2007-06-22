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


unless ARGV.size > 0
  $stderr.puts 'Missing query string.'
  exit -1
end

query = ARGV[0]

# search for artist
puts 'Query: ' << query
if mb.query MusicBrainz::Query::TrackInfoFromTRMId, query
  mb.select MusicBrainz::Query::Rewind

  1.upto(1000) { |i|
    # select first track from track list
    unless mb.select(MusicBrainz::Query::SelectTrack, i)
      puts 'That TRM is not in the database.' if i == 1
      break
    end

    track_uri = mb.result MusicBrainz::Query::TrackGetTrackId

    # extract the artist name from the track
    artist = mb.result(MusicBrainz::Query::TrackGetArtistName)
    puts 'Artist: ' << artist if artist

    # extract the track name
    track = mb.result(MusicBrainz::Query::TrackGetTrackName)
    puts 'Track: ' << track if track

    # extract the track duration
    dur = mb.result(MusicBrainz::Query::TrackGetTrackDuration)
    puts 'Duration: ' << dur  << ' ms' if dur

    mb.select MusicBrainz::Query::SelectTrackAlbum

    # extract the track number
    track_num = mb.ordinal MusicBrainz::Query::AlbumGetTrackList, track_uri
    puts 'TrackNum: ' << track_num.to_s if track_num > 0 && track_num < 100
      
    # extract the album name from the track
    album = mb.result(MusicBrainz::Query::AlbumGetAlbumName)
    puts 'Album: ' << album if album
  }
else
  $stderr.puts 'Error: ' << mb.error
end

