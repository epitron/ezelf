require 'rubygems'
#!/usr/bin/ruby

require 'musicbrainz'

# allocate a new MusicBrainz client
mb = MusicBrainz::Client.new

# handle environment variables
mb.server = server if server = ENV['MB_SERVER']
mb.debug = true if ENV['MB_DEBUG']
mb.depth = depth.to_i if depth = ENV['MB_DEPTH']
browser = ENV['BROWSER'] || 'mozilla'

# use the option on the command line as the device
mb.device = ARGV[0] if ARGV.size > 0

# get the URL for the CD in the CD-ROM drive
puts 'URL: ' << mb.url

puts "Launching browser #{browser}"
