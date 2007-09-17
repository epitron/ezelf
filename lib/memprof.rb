class MemoryProfiler
  DEFAULTS = {:delay => 10, :string_debug => false}

  def self.rss_and_size
    vm_info = File.read("/proc/self/status").grep(/^Vm(RSS|Size)/).map{|l| 
      l.chomp.gsub(/\t/, ' ').gsub(/ +/, ' ')
    }
    rss, size = vm_info.map{|l| l.scan(/\d+/).first.to_i}
  end

  def self.start(opt={})
    opt = DEFAULTS.dup.merge(opt)

    Thread.new do
      prev = Hash.new(0)
      curr = Hash.new(0)
      curr_strings = []
      delta = Hash.new(0)
      last_size, last_rss = 0, 0

      #puts "current dir: #{`pwd`}"
      #puts "rails root: #{RAILS_ROOT}"
      file = File.open('log/memory_profiler.log','w')

      loop do
        begin
          GC.start
          curr.clear

          curr_strings = [] if opt[:string_debug]

          ObjectSpace.each_object do |o|
            curr[o.class] += 1 #Marshal.dump(o).size rescue 1
            if opt[:string_debug] and o.class == String
              curr_strings.push o
            end
          end

          if opt[:string_debug]
            File.open("log/memory_profiler_strings.log.#{Time.now.to_i}",'w') do |f|
              curr_strings.sort.each do |s|
                f.puts s
              end
            end
            curr_strings.clear
          end

          delta.clear
          (curr.keys + delta.keys).uniq.each do |k,v|
            delta[k] = curr[k]-prev[k]
          end


          ## Display results
          file.puts

          file.puts "==[ Top 20 (#{Time.now}) =========================="
          delta.sort_by { |k,v| -v.abs }[0..19].sort_by { |k,v| -v}.each do |k,v|
            file.printf "%+5d: %s (%d)\n", v, k.name, curr[k] unless v == 0
          end

          rss, size = rss_and_size
          file.puts "----------------------------------"
          file.printf " RSS: %+d (%d)\nSize: %+d (%d)\n", rss-last_rss, rss, size-last_size, size
          file.puts
          last_size, last_rss = size, rss

          file.flush


          ## Clear stuff
          delta.clear
          prev.clear
          prev.update curr
          GC.start

        rescue Exception => err
          STDERR.puts "** memory_profiler error: #{err}"
        end
        sleep opt[:delay]
      end
    end
  end
end
