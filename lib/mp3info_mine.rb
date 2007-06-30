require 'pp'

# http://mpgedit.org/mpgedit/mpeg_format/MP3Format.html

module MP3
	class Info
		@@header_spec = [
			[12, :fsync, "Frame sync (all bits set)"],
			[1, :mpeg_version, "MPEG Audio version ID"],
			[2, :layer, "Layer description"],
			[1, :protection, "Protection bit"],
			[4, :bitrate_indexed, "Bitrate index"],
			[2, :sampling_rate_indexed, "Sampling rate frequency index (values are in Hz)"],
			[1, :padding, "Padding bit"],
			[1, :private, "Private bit. It may be freely used for specific needs of an application."],
			[2, :channel_mode, "Channel Mode"]
		]
			
		@@bitrate_index = {
			# ['bits', ],
			'0000' => [nil, nil, nil, nil, nil],
			'0001' => [32, 32, 32, 32, 8],
			'0010' => [64, 48, 40, 48, 16],
			'0011' => [96, 56, 48, 56, 24],
			'0100' => [128, 64, 56, 64, 32],
			'0101' => [160, 80, 64, 80, 40],
			'0110' => [192, 96, 80, 96, 48],
			'0111' => [224, 112, 96, 112, 56],
			'1000' => [256, 128, 112, 128, 64],
			'1001' => [288, 160, 128, 144, 80],
			'1010' => [320, 192, 160, 160, 96],
			'1011' => [352, 224, 192, 176, 112],
			'1100' => [384, 256, 224, 192, 128],
			'1101' => [416, 320, 256, 224, 144],
			'1110' => [448, 384, 320, 256, 160],
			'1111' => [nil, nil, nil, nil, nil],
		}
		
		@@sampling_rate_index = {
			#bits    MPEG1  MPEG2  MPEG2.5
			'00' => [44100, 22050, 11025],
			'01' => [48000, 24000, 12000],
			'10' => [32000, 16000, 8000],
			'11' => [nil, nil, nil],
		}
		
		@@version_index = {
			'0' => :v1,
			'1' => :v2,
		}
		
		@@layer_index = {
			'01' => :layer3,
			'10' => :layer2,
			'11' => :layer1,
		}
		
		@@version_and_layer_index = {
			'111' => 0, # 'V1,L1'
			'110' => 1, # 'V1,L2'
			'101' => 2, # 'V1,L3'
			'011' => 3, # 'V2,L1'
			'010' => 4, # 'V2,L2'
			'001' => 4, # 'V2,L3'
		}

		def self.generate_header_regex
			possible_bitstrings = @@version_and_layer_index.keys.map{|x| "1"*4 + x }
			possible_bitstrings.map!{|x| [x+'0', x+'1']}.flatten!
			pp possible_bitstrings
			regex = ["1"*8].pack('B8')
			regex += "[" + possible_bitstrings.map{|x| [x].pack('B8')}.join + "]"
			@@header_regex = Regexp.new regex
		end
		generate_header_regex


		### Initialize
		
		def initialize(filename)
			@file = open(filename, "rb")
			read_frame_header
		end


	
		# Find the bitrate given the header's bits
		
		def lookup_bitrate(bitrate_bits, version_bits, layer_bits)
			column = version_and_layer_index[version_bits+layer_bits]
			bitrate = bitrate_index[bitrate_bits][column]
			raise "Invalid bitrate" unless bitrate
			return bitrate
		end


		# Seek the file pointer to then next frame
		
		def seek_to_next_frame
			bs = 4096
			last = ''
			loop do
				startpos = @file.pos
				chunk = last + @file.read(bs)
				if header_index = chunk.index(@@header_regex)
					akljsdfasjd fjkasdhfklajhsf WRITE TESTS
				end
				last = chunk[-1..-1]
			end
		end
		
		def read_frame_header
			header = @file.read(4)
			
			bitstring = header.unpack("B32")[0]
			
			header = {}; offset = 0
			for numbits, symbol, desc in @@header_spec
				header[symbol] = bitstring[offset...offset+numbits]
				offset += numbits
			end
		end
	end
		
	
	
end
	
	
if $0 == __FILE__
	inf = MP3::Info.new "c:/mp3/Church Universal and Triumphant - Invocation for Judgement Against and Destruction of Rock Music.mp3"
end
