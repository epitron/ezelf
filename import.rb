require 'rubygems'
#require 'dbcon'
require 'config/environment'
require 'id3lib_with_extensions'

# http://id3lib-ruby.rubyforge.org/doc/index.html

Track.delete_all
Album.delete_all
Artist.delete_all

#SETTINGS.dirs = [ "/d/mp3/[PRE-CRASH]/Cake - Fashion Nugget (1996)" ]

for dir in SETTINGS.dirs
	puts "importing: #{dir}"
	for fullpath in Dir["#{dir}/**/*.mp3"]
		puts " - #{fullpath}"
		path = fullpath.gsub(dir, '').gsub(%r{^/}, '')
		Track.add_file(dir, path)
	end
end
