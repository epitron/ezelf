require 'rubygems'
require 'dbcon'
require 'id3lib'
require 'id3lib_extensions'

# http://id3lib-ruby.rubyforge.org/doc/index.html

Track.delete_all
Album.delete_all
Artist.delete_all

for dir in SETTINGS.dirs
	puts "importing: #{dir}"
	for fullpath in Dir["#{dir}/**/*.mp3"]
		puts " - #{file}"
		path = fullpath.gsub(dir, '').gsub(%r{^/}, '')
		Track.add_file(dir, path)
	end	
end
