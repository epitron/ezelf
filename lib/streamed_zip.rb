%w[ rubygems pp open3 activesupport ].each{|x| require x}

class StreamedZip
  ## TODO: Use arrays instead of string munging, then join results. (Wrapper class! (Pathname?))

  def initialize(paths)
    @paths = paths
  end

  def stream(opts={}, &block)
    paths = @paths
    parent_dirs  = opts[:parent_dirs] || 1
    chunk_size   = opts[:chunk_size]  || 25_000

    puts "* Streaming zip (#{paths.size} paths)..."

    root = common_root(paths, parent_dirs)
    puts "  |_ common root: #{root.inspect}"
    puts "  |_ chunk size: #{chunk_size} bytes"

    #open streams
    #out = open "test.zip", "wb"
    command = %{cd "#{root}"; zip -r -X -0 -@ -}
    puts "  |_ command: #{command.inspect}"
    stdin, stdout, stderr = Open3.popen3(command)

    #inject list
    puts "  |_ writing paths..."
    paths.map!{|path| relative_path(root, path)}
    paths.each{|path| stdin.puts(path); puts "    |_ #{path}"}
    stdin.close

    #read data
    puts "  |_ streaming..."
    loop do
      data = stdout.read(chunk_size)
      break unless data
      #out.write(data)
      yield data
    end
    puts


    #show zip output
    puts "  |_ done!"
    return stderr.read
  end


  def common_root(paths, parent_dirs)
    split_paths = paths.map{|p| p.split('/')}
    common = []
    n = 0

    loop do
      pieces = split_paths.map{|p| p[n]}

      first = pieces.first
      all_equal = pieces[1..-1].all?{|p| p == first}

      if all_equal
        common << first
      else
        break
      end
      n += 1
    end

    parent_dirs.times { common.pop }

    File.join(*common)
  end


  def relative_path(common_root, path)
    if path.starts_with?(common_root)
      path.gsub(common_root + "/", '')
    else
      raise "Doesn't contain common root: #{path} (root: #{common_root})"
    end
  end


  def close

  end


end

if $0 == __FILE__
  #collect files
  base = "/home/epi/ezelf/test/albums"
  dir = Dir["#{base}/*"].first
  filelist = Dir[ "#{dir}/*" ]
  pp filelist

  puts "---------"

  s = StreamedZip.new
  s.stream(filelist) do |chunk|
    print "."
  end

end
