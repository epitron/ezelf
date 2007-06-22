require 'rubygems'
#require 'dbcon'
require 'config/environment'
require 'id3lib_with_extensions'

# http://id3lib-ruby.rubyforge.org/doc/index.html

Track.delete_all
Album.delete_all
Artist.delete_all

#SETTINGS.dirs = [ "/d/mp3/[PRE-CRASH]/Cake - Fashion Nugget (1996)" ]

for source in Source.find(:all)

    next unless source.dir?

    puts "===== source: #{source.name} ========================"
    puts "from: #{source.uri}"
    puts

    root = source.uri
    for mp3path in Dir["#{root}/**/*.mp3"]

        # remove the root, and the leading slash
        mp3path = mp3path.gsub(root, '').gsub(%r{^/}, '')
        puts " - #{mp3path}"

        # create a new track
        Track.add_file(source, mp3path)

    end

    puts

end
