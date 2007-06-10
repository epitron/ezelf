require 'rubygems'
require 'dbcon'
require 'id3lib'

# http://id3lib-ruby.rubyforge.org/doc/index.html

for dir in SETTINGS.dirs
	puts "importing: #{dir}"
	for file in Dir["#{dir}/**/*.mp3"]
		puts " - #{file}"
		Track.add_file(file)
	end	
end
