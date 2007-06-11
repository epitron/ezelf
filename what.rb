require 'rubygems'
require 'config/settings'
require 'id3lib'

# http://id3lib-ruby.rubyforge.org/doc/index.html

for dir in SETTINGS.dirs
	puts "importing: #{dir}"
	#for file in Dir["#{dir}/Bombay the Hard Way (Vol. 2) - Electric Vindaloo/*.mp3"]
	for file in Dir["C:/mp3/[Mixes, Live Sets]/2 Much 2 Many DJs/2 Many DJs - 50,000,000 Soulwax Fans Can't Be Wrong - 2005/CD1/*.mp3"]
		puts "* #{file}"
		tag = ID3Lib::Tag.new(file)
		
		tag.each do |frame|
     		puts "  |_ #{frame.inspect}"
   		end
   		
   		puts
   		puts
		#Track.add_file(file)
	end	
end
