# load the musicbrainz library
require 'rubygems'
require 'musicbrainz'

# create a musicbrainz trm handle
trm = MusicBrainz::TRM.new

# prepare for CD-quality audio
samples, channels, bits = 44100, 2, 16
trm.pcm_data samples, channels, bits

# read data from file and pass it to the TRM handle
# until MusicBrainz has enough information to generate
# a signature
fh = open(ARGV[0] || 'test/test.mp3','rb')
while buf = fh.read(4096)
    break if trm.generate_signature(buf)
end

# check for signature
if sig = trm.finalize_signature
    # print human-readable version of signature
    puts trm.convert_sig(sig)
else
    $stderr.puts "Couldn't generate signature"
end
