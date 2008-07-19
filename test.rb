require 'lib/taglib'
require 'pp'

puts "listing files.."
files = Dir["/home/epi/mp3/epitron/**/*.mp3"]

puts "getting tags..."
for file in files
  tag = TagLib::File.new file
  h = tag.to_h
  puts " - #{file}"
end

__END__
	puts "#{tag.title}"
	puts "#{tag.artist}"
	puts "#{tag.album}"
	puts "#{tag.comment}"
	puts "#{tag.genre}"
	puts "#{tag.year}"
	puts "#{tag.track}"
	puts "#{tag.length}"
	puts "#{tag.bitrate}"
	puts "#{tag.samplerate}"
	puts "#{tag.channels}"

