require 'rubygems'
#require 'config/settings'
require 'id3lib'

# http://id3lib-ruby.rubyforge.org/doc/index.html

dirs = ARGV.size > 0 ? ARGV : ["test/albums/2 Many DJs**"]

for dir in dirs
    puts "scanning: #{dir}"
    #for file in Dir["#{dir}/Bombay the Hard Way (Vol. 2) - Electric Vindaloo/*.mp3"]
    scanstr = "#{dir}/**/*.mp3"
    p scanstr
    files = Dir[scanstr]
    p files
    for file in files
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
