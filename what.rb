require 'rubygems'
require 'config/settings'
require 'id3lib'

# http://id3lib-ruby.rubyforge.org/doc/index.html

for dir in SETTINGS.dirs
	puts "importing: #{dir}"
	for file in Dir["#{dir}/Bombay the Hard Way (Vol. 2) - Electric Vindaloo/*.mp3"]
		puts " - #{file}"
		tag = ID3Lib::Tag.new(file)
		pp tag
		puts "** artist: #{tag.artist}"
		puts "** album: #{tag.album}"
		#Track.add_file(file)
	end	
end
