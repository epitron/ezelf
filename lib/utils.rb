
def dir_tree(base)
  raise "[utils.rb: dir_tree()] base dir doesn't exist: #{base}" unless File.exists? base

  files = Dir["#{base}/**/*.{mp3,ogg,mod,m4a,mp4}"].sort
  files.map! do |path|
    dir, fn = File.split path
    reldir = dir.gsub("#{base}/",'')
    [reldir, fn]
  end

  tree = {}
  for reldir, fn in files
    tree[reldir] ||= []
    tree[reldir] << fn
  end

  tree #.to_a.sort
end
