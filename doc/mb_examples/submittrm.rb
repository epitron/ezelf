#!/usr/bin/ruby 

require 'musicbrainz'

# allocate a new MusicBrainz client
mb = MusicBrainz::Client.new
mb.depth = 2

# handle environment variables
mb.server = server if server = ENV['MB_SERVER']
mb.debug = true if ENV['MB_DEBUG']
mb.depth = depth.to_i if depth = ENV['MB_DEPTH']

unless ARGV.size > 3
  $stderr.puts 'Missing authentication and query strings.'
  exit -1
end

auth = [ARGV[0], ARGV[1]]
query = [ARGV[2], ARGV[3]]

if mb.auth *auth
  puts 'Authenticated ok.'

  if mb.query(MusicBrainz::Query::SubmitTrackTRMId, *query)
    puts 'TRM submitted.  Thanks!'
  else
    $stderr.puts 'Error: ' << mb.error
  end
else
  $stderr.puts 'Authentication Failed: ' << mb.error
end
