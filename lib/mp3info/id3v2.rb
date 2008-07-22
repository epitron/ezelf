require "delegate"
require "iconv"

require "mp3info/extension_modules"

class ID3v2Error < StandardError ; end

# This class is not intended to be used directly
class ID3v2 < DelegateClass(Hash) 
  
  # Major version used when writing tags
  WRITE_VERSION = 3
  
  TAGS = {
    "AENC" => "Audio encryption",
    "APIC" => "Attached picture",
    "COMM" => "Comments",
    "COMR" => "Commercial frame",
    "ENCR" => "Encryption method registration",
    "EQUA" => "Equalization",
    "ETCO" => "Event timing codes",
    "GEOB" => "General encapsulated object",
    "GRID" => "Group identification registration",
    "IPLS" => "Involved people list",
    "LINK" => "Linked information",
    "MCDI" => "Music CD identifier",
    "MLLT" => "MPEG location lookup table",
    "OWNE" => "Ownership frame",
    "PRIV" => "Private frame",
    "PCNT" => "Play counter",
    "POPM" => "Popularimeter",
    "POSS" => "Position synchronisation frame",
    "RBUF" => "Recommended buffer size",
    "RVAD" => "Relative volume adjustment",
    "RVRB" => "Reverb",
    "SYLT" => "Synchronized lyric/text",
    "SYTC" => "Synchronized tempo codes",
    "TALB" => "Album/Movie/Show title",
    "TBPM" => "BPM (beats per minute)",
    "TCOM" => "Composer",
    "TCON" => "Content type",
    "TCOP" => "Copyright message",
    "TDAT" => "Date",
    "TDLY" => "Playlist delay",
    "TENC" => "Encoded by",
    "TEXT" => "Lyricist/Text writer",
    "TFLT" => "File type",
    "TIME" => "Time",
    "TIT1" => "Content group description",
    "TIT2" => "Title/songname/content description",
    "TIT3" => "Subtitle/Description refinement",
    "TKEY" => "Initial key",
    "TLAN" => "Language(s)",
    "TLEN" => "Length",
    "TMED" => "Media type",
    "TOAL" => "Original album/movie/show title",
    "TOFN" => "Original filename",
    "TOLY" => "Original lyricist(s)/text writer(s)",
    "TOPE" => "Original artist(s)/performer(s)",
    "TORY" => "Original release year",
    "TOWN" => "File owner/licensee",
    "TPE1" => "Lead performer(s)/Soloist(s)",
    "TPE2" => "Band/orchestra/accompaniment",
    "TPE3" => "Conductor/performer refinement",
    "TPE4" => "Interpreted, remixed, or otherwise modified by",
    "TPOS" => "Part of a set",
    "TPUB" => "Publisher",
    "TRCK" => "Track number/Position in set",
    "TRDA" => "Recording dates",
    "TRSN" => "Internet radio station name",
    "TRSO" => "Internet radio station owner",
    "TSIZ" => "Size",
    "TSRC" => "ISRC (international standard recording code)",
    "TSSE" => "Software/Hardware and settings used for encoding",
    "TYER" => "Year",
    "TXXX" => "User defined text information frame",
    "UFID" => "Unique file identifier",
    "USER" => "Terms of use",
    "USLT" => "Unsychronized lyric/text transcription",
    "WCOM" => "Commercial information",
    "WCOP" => "Copyright/Legal information",
    "WOAF" => "Official audio file webpage",
    "WOAR" => "Official artist/performer webpage",
    "WOAS" => "Official audio source webpage",
    "WORS" => "Official internet radio station homepage",
    "WPAY" => "Payment",
    "WPUB" => "Publishers official webpage",
    "WXXX" => "User defined URL link frame"
  }

  # See id3v2.4.0-structure document, at section 4.
  TEXT_ENCODINGS = ["iso-8859-1", "utf-16", "utf-16be", "utf-8"]

  include Mp3Info::HashKeys
  
  # this is the position in the file where the tag really ends
  attr_reader :io_position

  # :+lang+: for writing comments
  #
  # :+encoding+: one of the string of +TEXT_ENCODINGS+, 
  # used as a source and destination encoding respectively
  # for read and write tag2 values.
  attr_reader :options
  
  # you can access this object like an hash, with [] and []= methods
  # special cases are ["disc_number"] and ["disc_total"] mirroring TPOS attribute
  def initialize(options = {})
    @options = { 
      :lang => "ENG",
      :encoding => "iso-8859-1"
    }

    @options.update(options)
    @text_encoding_index = TEXT_ENCODINGS.index(@options[:encoding])
    
    unless @text_encoding_index
      raise(ArgumentError, "bad id3v2 text encoding specified")
    end

    @hash = {}
    #TAGS.keys.each { |k| @hash[k] = nil }
    @hash_orig = {}
    super(@hash)
    @valid = false
    @version_maj = @version_min = nil
  end

  # does this tag has been correctly read ?
  def valid?
    @valid
  end

  # does this tag has been changed ?
  def changed?
    @hash_orig != @hash
  end
  
  # full version of this tag (like "2.3.0") or nil
  # if tag was not correctly read
  def version
    if valid?
      "2.#{@version_maj}.#{@version_min}"
    else
      nil
    end
  end

  ### gets id3v2 tag information from io object (must support #seek() method)
  def from_io(io)
    @io = io
    original_pos = @io.pos
    @io.extend(Mp3Info::Mp3FileMethods)
    version_maj, version_min, flags = @io.read(3).unpack("CCB4")
    @unsync, ext_header, experimental, footer = (0..3).collect { |i| flags[i].chr == '1' }
    raise(ID3v2Error, "can't find version_maj ('#{version_maj}')") unless [2, 3, 4].include?(version_maj)
    @version_maj, @version_min = version_maj, version_min
    @valid = true
    @tag_length = @io.get_syncsafe
    case @version_maj
      when 2
        read_id3v2_2_frames
      when 3, 4
        # seek past extended header if present
        @io.seek(@io.get_syncsafe - 4, IO::SEEK_CUR) if ext_header
        read_id3v2_3_frames
    end

    @io.seek(original_pos + @tag_length, IO::SEEK_SET)

    # skip padding zeros at the end of the tag
    while @io.getbyte == 0; end

    @io.seek(-1, IO::SEEK_CUR)
    @io_position = @io.pos
    
    @hash_orig = @hash.dup
    #no more reading
    @io = nil
    # we should now have io sitting at the first MPEG frame
  end

  # dump tag for writing. Version is always 2.#{WRITE_VERSION}.0.
  def to_bin
    #TODO handle of @tag2[TLEN"]
    #TODO add of crc
    #TODO add restrictions tag

    tag = ""
    @hash.each do |k, v|
      next unless v
      next if v.respond_to?("empty?") and v.empty?
      # doesn't encode id3v2.2 tags, which have 3 characters
      next if k.size != 4 
      data = encode_tag(k, v.to_s, WRITE_VERSION)
      #data << "\x00"*2 #End of tag

      tag << k[0,4]   #4 characte max for a tag's key
      #tag << to_syncsafe(data.size) #+1 because of the language encoding byte
      size = data.size
      if RUBY_VERSION >= "1.9.0"
        size = data.dup.force_encoding("binary").size
      end
      tag << [size].pack("N") #+1 because of the language encoding byte
      tag << "\x00"*2 #flags
      tag << data
    end

    tag_str = "ID3"
    #version_maj, version_min, unsync, ext_header, experimental, footer 
    tag_str << [ WRITE_VERSION, 0, "0000" ].pack("CCB4")
    tag_str << [to_syncsafe(tag.size)].pack("N")
    tag_str << tag
    puts "tag in binary format: #{tag_str.inspect}" if $DEBUG
    tag_str
  end

  private

  def encode_tag(name, value, version)
    puts "encode_tag(#{name.inspect}, #{value.inspect}, #{version})" if $DEBUG

    text_encoding_index = @text_encoding_index 
    if (name.index("T") == 0 || name == "COMM" ) && version == 3
      # in id3v2.3 tags, there is only 2 encodings possible
      transcoded_value = value
      if text_encoding_index >= 2
	transcoded_value = Iconv.iconv(TEXT_ENCODINGS[1], TEXT_ENCODINGS[text_encoding_index], value).first
	text_encoding_index = 1
      end
    end

    case name
      when "COMM"
	[ text_encoding_index , @options[:lang], 0, transcoded_value ].pack("ca3ca*")
      when /^T/
	text_encoding_index.chr + transcoded_value
      else
        value
    end
  end

  ### Read a tag from file and perform UNICODE translation if needed
  def decode_tag(name, raw_value)
    puts("decode_tag(#{name.inspect}, #{raw_value.inspect})") if $DEBUG
    case name
      when "COMM"
        #FIXME improve this
	encoding, lang, str = raw_value.unpack("ca3a*") 
	out = raw_value.split(0.chr).last
      when /^T/
	encoding = raw_value.getbyte(0) # language encoding (see TEXT_ENCODINGS constant)   
	out = raw_value[1..-1] 
	# we need to convert the string in order to match
	# the requested encoding
	if out && encoding != @text_encoding_index
	  begin
	    Iconv.iconv(@options[:encoding], TEXT_ENCODINGS[encoding], out).first
	  rescue Iconv::Failure
	    out
	  end
	else
	  out
	end
      else
        raw_value
    end
  end

  ### reads id3 ver 2.3.x/2.4.x frames and adds the contents to @tag2 hash
  ### NOTE: the id3v2 header does not take padding zero's into consideration
  def read_id3v2_3_frames
    loop do # there are 2 ways to end the loop
      name = @io.read(4)
      if name.getbyte(0) == 0 or name == "MP3e" #bug caused by old tagging application "mp3ext" ( http://www.mutschler.de/mp3ext/ )
        @io.seek(-4, IO::SEEK_CUR)    # 1. find a padding zero,
	seek_to_v2_end
        break
      else               
	if @version_maj == 4
	  size = @io.get_syncsafe
	else
	  size = @io.get32bits
	end
        @io.seek(2, IO::SEEK_CUR)     # skip flags
        puts "name '#{name}' size #{size}" if $DEBUG
        add_value_to_tag2(name, size)
      end
      break if @io.pos >= @tag_length # 2. reach length from header
    end
  end    

  ### reads id3 ver 2.2.x frames and adds the contents to @tag2 hash
  ### NOTE: the id3v2 header does not take padding zero's into consideration
  def read_id3v2_2_frames
    loop do
      name = @io.read(3)
      if name.getbyte(0) == 0
        @io.seek(-3, IO::SEEK_CUR)
	seek_to_v2_end
        break
      else
        size = (@io.getbyte << 16) + (@io.getbyte << 8) + @io.getbyte
	add_value_to_tag2(name, size)
        break if @io.pos >= @tag_length
      end
    end
  end    
  
  ### Add data to tag2["name"]
  ### read lang_encoding, decode data if unicode and
  ### create an array if the key already exists in the tag
  def add_value_to_tag2(name, size)
    puts "add_value_to_tag2" if $DEBUG

    if size > 50_000_000
      raise ID3v2Error, "tag size too big for tag '#{name}'"
    end
      
    data_io = @io.read(size)
    data = decode_tag(name, data_io)
    # remove padding zeros for textual tags
    if name =~ /^T/
      data.sub!(/\0*$/, '')
    end

    if self["TPOS"] =~ /(\d+)\s*\/\s*(\d+)/
      self["disc_number"] = $1.to_i
      self["disc_total"] = $2.to_i
    end

    if self.keys.include?(name)
      unless self[name].is_a?(Array)
        self[name] = [ self[name] ]
      end
      self[name] << data
    else
      self[name] = data 
    end
    p data if $DEBUG
  end
  
  ### runs thru @file one char at a time looking for best guess of first MPEG
  ###  frame, which should be first 0xff byte after id3v2 padding zero's
  def seek_to_v2_end
    until @io.getbyte == 0xff
      raise EOFError if @io.eof?
    end
    @io.seek(-1, IO::SEEK_CUR)
  end
  
  ### convert an 32 integer to a syncsafe string
  def to_syncsafe(num)
    ( (num<<3) & 0x7f000000 )  + ( (num<<2) & 0x7f0000 ) + ( (num<<1) & 0x7f00 ) + ( num & 0x7f )
  end

#  def method_missing(meth, *args)
#    m = meth.id2name
#    return nil if TAGS.has_key?(m) and self[m].nil?
#    super
#  end
end

