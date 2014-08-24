require 'pathname'
require 'pp'

### This is a shitty class!


  def directory_tree(root)
    tree = {}
    Pathname.new(root).entries.each do |entry|
      p entry
      next if entry.to_s == "." or entry.to_s == ".."
      if entry.directory?
        puts "  directory: #{entry}"
        tree[entry] = directory_tree(entry)
      elsif entry.file?
        puts "  file: #{entry}"
        tree[entry] = entry
      else
        puts "  other? #{entry}"
      end
    end
    tree
  end



if $0 == __FILE__
  pp directory_tree("app")
end
  