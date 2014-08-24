require 'rubygems'
#!/usr/bin/ruby 

# load musicbrainz library
require 'musicbrainz'

def die(*args)
  $stderr.puts(*args) 
  exit -1
end

QueryResult = Struct.new(:name, :query, :is_id)

QUERY_RESULTS = [
  QueryResult.new('Album',    'AlbumGetAlbumName',      false),
  QueryResult.new('AlbumId',  'AlbumGetAlbumId',        true),
  QueryResult.new('ArtistId', 'AlbumGetAlbumArtistId',  true),
]

# check command-line arguments
die("Usage #$0 <query string>") unless ARGV.size > 0

# grab query string
query_string = ARGV[0]

# allocate a new MusicBrainz client
mb = MusicBrainz::Client.new
mb.max_items = 10

# handle environment variables
mb.server = server if server = ENV['MB_SERVER']
mb.debug = true if ENV['MB_DEBUG']
mb.depth = depth.to_i if depth = ENV['MB_DEPTH']

# search for album
puts 'Query: ' << query_string
query_ok = mb.query MusicBrainz::Query::FindAlbumByName, query_string
die("Error: #{mb.error}") unless query_ok

# get number of results
num_albums = mb.result(MusicBrainz::Query::GetNumAlbums).to_i
die("No albums found." ) unless num_albums > 0
puts "Found #{num_albums} albums."

# print result column headers
puts QUERY_RESULTS.map { |result| result.name }.join(',')

# iterate over result list and print each one out
1.upto(num_albums) do |i|
  # back up to the top context and select the Ith album
  mb.select MusicBrainz::Query::Rewind
  mb.select MusicBrainz::Query::SelectAlbum, i

  puts QUERY_RESULTS.map { |result|
    val = mb.result(MusicBrainz::Query.const_get(result.query))
    result.is_id ? mb.id_from_url(val) : val
  }.join(',')
end
