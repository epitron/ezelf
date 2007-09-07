require 'pp'

### ActiveRecord
#puts "loading dbcon..."
#require 'dbcon'
puts "loading rails environment..."
require 'config/environment'

### Mp3Info
puts "loading mp3info_with_extensions..."
require 'mp3info_with_extensions'

# http://id3lib-ruby.rubyforge.org/doc/index.html

puts "deleting all Tracks, Albums and Artists..."
Track.delete_all
Album.delete_all
Artist.delete_all

sources = Source.find(:all)

pp sources.map{|s|[s.name, s.uri]}

if sources.any?

	for source in sources
		puts "checking dir: #{source.uri}"
		puts File.directory?(source.uri) ? "...exists!" : "...NOT exists?!?!"
	    next unless source.dir?
	
	    puts "===== importing all tracks from #{source.name} ========================"
	    puts "uri: #{source.uri}"
	    puts
	
	    root = source.uri
	    for mp3path in Dir["#{root}/**/*.mp3"]
	
	        # remove the root, and the leading slash
	        mp3path = mp3path.gsub(root, '').gsub(%r{^/}, '')
	        puts " - #{mp3path}"
	
	        # create a new track
	        begin
	        	Track.add_file(source, mp3path)
    	    rescue Mp3InfoError, NoMemoryError
			puts "Error parsing mp3"
	    		next
    		end
	    end
	end
	
else
	puts "No sources?"
end
