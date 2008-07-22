require '../config/environment'
require 'rio'
require 'rubygems'

for source in Source.all
  source.tree
  AudioInfo::Album.new(path, fast_lookup = false)
end
