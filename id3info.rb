$: << "lib"

require 'pp'
require 'mp3info'

# http://id3lib-ruby.rubyforge.org/doc/index.html

for arg in ARGV
	puts "arg: #{arg}"
	if File.directory?(arg)
		files = Dir["#{arg}/**/*.mp3"]
	else
		files = [arg]
	end
	
	for file in files
	    puts "* #{file}"
	    mp3 = Mp3Info::new(file)
	    pp mp3
	    #pp mp3.tag
	
	    #tag.each do |frame|
	    #    puts "  |_ #{frame.inspect}"
	    #end
	
	    puts
	    puts
    end
end
