#!/usr/bin/ruby
require 'pathname'

$: << File.join( Pathname.new(__FILE__).realpath.dirname, "lib" )

require 'pp'
require 'mp3info_with_extensions'

# http://id3lib-ruby.rubyforge.org/doc/index.html

def show_in_table(pairs, title=nil)
  maxa = 0
  for a,b in pairs
    maxa = a.size if a.size > maxa
    #maxb = b.size if b.size > maxb
  end
  
  if title
    puts title
    puts "-" * 60
  end
  
  for a,b in pairs
    fmtstr = "%#{maxa}.#{maxa}s | %s"
    puts fmtstr % [a,b.inspect]
  end
  
  puts
end

puts "===================================================="
puts "MP3 STATS-o-MATIC-tron!!!!"
puts "===================================================="
puts

for arg in ARGV
	puts "processing: #{arg}"
	puts
	if File.directory?(arg)
		files = Dir["#{arg}/**/*.mp3"]
	else
		files = [arg]
	end
	
	arrays = %w{@tag @tag_orig @tag1_orig @tag2 @tag1}
	
	for file in files
	    x = "****#{"*" * file.size}****"
	    puts x
	    puts "*** #{file} ***"
	    puts x
	    puts
	    mp3 = Mp3Info::new(file)
	    #pp mp3
	    stats = mp3.instance_variables - arrays

      #stats.sort.each{|stat| puts "%20.20s | %s" % [stat,  }
      show_in_table stats.sort.map{|stat| [stat, mp3.instance_variable_get(stat)] }, "Statistics:"
      
	    %w{@tag @tag1 @tag2}.each do |array|
	      a = mp3.instance_variable_get array
	      show_in_table a, array
      end
	    
    end
end
