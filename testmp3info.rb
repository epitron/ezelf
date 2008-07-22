$: << "lib"
require 'pp'
require 'mp3info'

i = Mp3Info.new("test/albums/Whitey - The Light at the End of the Tunnel is a Train (2005)/Whitey - 01 - Intro, In The Limelight.mp3")
pp i.tag
