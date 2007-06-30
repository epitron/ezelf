# $Id: mp3info.rb,v 1.20 2001/10/08 01:46:42 toki Exp $
# --
# 説明:
#   MP3 ファイルの情報を操作するライブラリ。
#
# クラス・モジュール:
#   class MPEGAudioStreamFile
#   class MPEGAudioStreamFile::NotMPEGAudioStreamError
#   class MPEGAudioStreamFile::BitVector
#   class MPEGAudioStreamFile::Header
#   class MPEGAudioStreamFile::Frame
#   class MP3Tag
#   class MP3Tag::Loader
#   class ID3Tag
#   class RIFF
#
# 各クラス・モジュールの関係:
#   [MPEGAudioStreamFile]
#     (none)
#   [MPEGAudioStreamFile::NotMPEGAudioStreamError]
#     <superclass>
#       StandardError
#   [MPEGAudioStreamFile::BitVector]
#     (none)
#   [MPEGAudioStreamFile::Header]
#     (none)
#   [MPEGAudioStreamFile::Frame]
#     (none)
#   [MP3Tag]
#     (none)
#   [MP3Tag::Loader]
#     (none)
#   [ID3Tag]
#     <superclass>
#       MP3Tag
#   [RIFF]
#     <superclass>
#       MP3Tag
#
# 各クラス・モジュールの定数:
#   [MPEGAudioStreamFile]
#     (none)
#   [MPEGAudioStreamFile::NotMPEGAudioStreamError]
#     (none)
#   [MPEGAudioStreamFile::BitVector]
#     (none)
#   [MPEGAudioStreamFile::Header]
#     (none)
#   [MPEGAudioStreamFile::Frame]
#     MPEG_VER
#     MPEG_VER_NUM
#     MPEG_LAYER
#     MPEG_LAYER_NUM
#     ERR_PROTECT
#     BITRATE
#     SAMPLING
#     SAMPLES
#     MODE
#     COPYRIGHT
#     ORIGINAL
#     EMPHASIS
#   [MP3Tag]
#     LOADER
#   [MP3Tag::Loader]
#     (none)
#   [ID3Tag]
#     GENRE
#     GENRE_PATTERN
#     TAG_SIZE
#   [RIFF]
#     TAG_MAP
#
# 各クラス・モジュールのメソッド:
#   [MPEGAudioStreamFile]
#     <class method>
#       new(filename)
#       mpeg_audio?(filename)
#       mpeg_audio_error(filename)
#     <public method>
#       filename
#       read
#       version
#       version_num
#       layer
#       layer_num
#       error_protection
#       bitrate
#       sampling
#       mode
#       mode_num
#       copyright
#       original
#       frames
#       minutes
#       remaining_seconds
#       seconds
#       file_size
#     <private method>
#       get { ... }
#   [MPEGAudioStreamFile::NotMPEGAudioStreamError]
#     (none)
#   [MPEGAudioStreamFile::BitVector]
#     <class method>
#       new(byte_str)
#     <public method>
#       [](offset, length)
#   [MPEGAudioStreamFile::Header]
#     <module function>
#       header?(byte1, byte2)
#     <class method>
#       new(bit_vec)
#     <public method>
#       version
#       layer
#       error_protection
#       bitrate
#       sampling
#       padding
#       private
#       mode
#       extension
#       copyright
#       original
#       emphasis
#   [MPEGAudioStreamFile::Frame]
#     <class method>
#       new(header, filename)
#     <public method>
#       filename
#       version
#       version_num
#       layer
#       layer_num
#       error_protection
#       bitrate
#       sampling
#       samples
#       padding
#       private
#       mode
#       mode_num
#       extension
#       extension_num
#       copyright
#       original
#       emphasis
#       emphasis_num
#       size
#     <private>
#       get(table, *indices)
#   [MP3Tag]
#     <class method>
#       new(filename)
#       has_tag?(filename)
#     <public method>
#       filename
#       read
#       write
#       erase
#       wipe
#       has_tag?
#       title
#       title=(title)
#       artist
#       artist=(artist)
#       album
#       album=(album)
#       year
#       year=(year)
#       comment
#       comment=(comment)
#       genre
#       genre=(genre)
#     <private method>
#       read_tag(file)
#       write_tag(file)
#       erase_tag(file)
#       get { ... }
#   [ID3Tag]
#     <class method>
#       new(filename)
#       has_tag?(filename)
#       add_loader(klass)
#       inherited(klass)
#     <public method>
#       filename
#       read
#       write
#       wipe
#       has_tag?
#       title
#       title=(title)
#       artist
#       artist=(artist)
#       album
#       album=(album)
#       year
#       year=(year)
#       comment
#       comment=(comment)
#       genre_num
#       genre_num=(num)
#       genre
#     <private method>
#       has_tag(file)
#       has_tag(file) { |tag_list| ... }
#       get { ... }
#   [MP3Tag::Loader]
#     <class method>
#       new(klass)
#     <public method>
#       load(filename)
#   [ID3Tag]
#     <public method>
#       genre=(genre)
#       genre_num
#       genre_num=(genre_num)
#     <private method>
#       test_read(file)
#       read_tag(file)
#       write_tag(file)
#       erase_tag(file)
#   [RIFF]
#     <public method>
#       riff(file)
#       read_tag(file)
# 資料:
#   <<< MPEG AUDIO FRAME HEADER >>>
#     http://www.dv.co.yu/mpgscript/mpeghdr.htm
#   <<< ID3 TAG >>>
#     http://www.freeamp.org/id3/id3v1.html
#     http://members.xoom.com/daicyan/
#   <<< RIFF >>>
#     http://www.angel.ne.jp/~mike/index.html
#

class MPEGAudioStreamFile
  class NotMPEGAudioStreamError < StandardError
  end

  def self::mpeg_audio_error(filename)
    raise NotMPEGAudioStreamError, "not a MPEG audio stream file: #{filename}"
  end

  class BitVector
    def initialize(byte_str)
      @bits = 0
      byte_str.each_byte do |byte|
	@bits <<= 8
	@bits |= byte
      end
    end

    def [](offset, length)
      mask = 0
      length.times do
	mask <<= 1
	mask |= 1
      end
      (@bits >> offset) & mask
    end
  end

  class Header
    def self::header?(upper, lower)
      upper == 0xFF && (lower & 0xC0) == 0xC0
    end

    def initialize(bit_vec)
      @version          = bit_vec[19, 2]
      @layer            = bit_vec[17, 2]
      @error_protection = bit_vec[16, 1]
      @bitrate          = bit_vec[12, 4]
      @sampling         = bit_vec[10, 2]
      @padding          = bit_vec[9,  1]
      @private          = bit_vec[8,  1]
      @mode             = bit_vec[6,  2]
      @extension        = bit_vec[4,  2]
      @copyright        = bit_vec[3,  1]
      @original         = bit_vec[2,  1]
      @emphasis         = bit_vec[0,  2]
    end

    attr_reader :version
    attr_reader :layer
    attr_reader :error_protection
    attr_reader :bitrate
    attr_reader :sampling
    attr_reader :padding
    attr_reader :private
    attr_reader :mode
    attr_reader :extension
    attr_reader :copyright
    attr_reader :original
    attr_reader :emphasis
  end

  class Frame
    MPEG_VER = [ "MPEG 2.5", nil, "MPEG 2.0", "MPEG 1.0" ]
    MPEG_VER_NUM = [ 2.5, nil, 2, 1 ]
    MPEG_LAYER = [ nil, "III", "II", "I" ]
    MPEG_LAYER_NUM = [ nil, 3, 2, 1 ]
    ERR_PROTECT = [ true, false ]

    mpeg1_bitrate = [
      # reserved
      nil,
      # Layer III
      [ nil, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, nil ],
      # Layer II
      [ nil, 32, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384, nil ],
      # Layer I
      [ nil, 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, nil ]
    ]

    mpeg2_layer23_bitrate = [
      nil, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, nil
    ]

    mpeg2_bitrate = [
      # reserved
      nil,
      # Layer III
      mpeg2_layer23_bitrate,
      # Layer II
      mpeg2_layer23_bitrate,
      # Layer I
      [ nil, 32, 48, 56, 64, 80, 96, 112, 128, 144, 160, 176, 192, 224, 256, nil ]
    ]

    BITRATE = [
      mpeg2_bitrate,		# MPEG 2.5
      nil,			# reserved
      mpeg2_bitrate,		# MPEG 2
      mpeg1_bitrate		# MPEG 1
    ]

    SAMPLING = [
      [ 11025, 12000, 8000 ],	# MPEG 2.5
      nil,			# reserved
      [ 22050, 24000, 16000 ],	# MPEG 2
      [ 44100, 48000, 32000 ]	# MPEG 1
    ]

    SAMPLES = [
      nil,			# reserved
      1152,			# Layer III
      1152,			# Layer II
      384			# Layer I
    ]

    MODE = [ "Stereo", "Joint Stereo", "Dual Channel", "Single Channel" ]
    COPYRIGHT = [ false, true ]
    ORIGINAL = [ false, true ]
    EMPHASIS = [ "none", "50/15 ms", nil, "CCIT J.17" ]

    def get(table, *indices)
      for index in indices
	table = table[index]
	if (table == nil) then
	  MPEGAudioStreamFile::mpeg_audio_error(@filename)
	end
      end
      table
    end
    private :get

    def initialize(header, filename)
      @filename = filename

      @version          = get(MPEG_VER, header.version)
      @version_num      = get(MPEG_VER_NUM, header.version)
      @layer            = get(MPEG_LAYER, header.layer)
      @layer_num        = get(MPEG_LAYER_NUM, header.layer)
      @error_protection = get(ERR_PROTECT, header.error_protection)
      @bitrate          = get(BITRATE, header.version, header.layer, header.bitrate)
      @sampling         = get(SAMPLING, header.version, header.sampling)
      @samples          = get(SAMPLES, header.layer)
      @padding          = header.padding
      @private          = header.private
      @mode             = get(MODE, header.mode)
      @mode_num         = header.mode
      @extension        = header.extension
      @extension_num    = @extension
      @copyright        = get(COPYRIGHT, header.copyright)
      @original         = get(ORIGINAL, header.original)
      @emphasis         = get(EMPHASIS, header.emphasis)
      @emphasis_num     = header.emphasis
    end

    attr_reader :filename
    attr_reader :version
    attr_reader :version_num
    attr_reader :layer
    attr_reader :layer_num
    attr_reader :error_protection
    attr_reader :bitrate
    attr_reader :sampling
    attr_reader :samples
    attr_reader :padding
    attr_reader :private
    attr_reader :mode
    attr_reader :mode_num
    attr_reader :extension
    attr_reader :extension_num
    attr_reader :copyright
    attr_reader :original
    attr_reader :emphasis
    attr_reader :emphasis_num

    def size
      case (layer_num)
      when 1
	12 * 1000 * bitrate / sampling + 4 * padding
      when 2, 3
	144 * 1000 * bitrate / sampling + padding
      end
    end
  end

  def initialize(filename)
    @filename = filename
    @frame = nil
  end

  attr_reader :filename

  def read
    File::open(@filename) do |file|
      stat = file.stat
      @file_size = stat.size
      if (stat.blksize != 0 && stat.blksize > 1024) then
	blksize = stat.blksize
      else
	blksize = 1024
      end
      buf = file.read(blksize)
      for pos in 0..(buf.size - 4)
	if (Header::header?(buf[pos], buf[pos + 1])) then
	  bit_vec = BitVector::new(buf[pos, 4])
	  header = Header::new(bit_vec)
	  @frame = Frame::new(header, @filename)

	  # これらの値は近似値なので、正確ではない。
	  @frames = @file_size / @frame.size
	  @seconds = @frames * @frame.samples / @frame.sampling
	  @minutes = @seconds / 60
	  @remaining_seconds = @seconds % 60

	  # 次のフレームをチェックする。
	  next_pos = pos + @frame.size
	  if (next_pos < buf.size - 1) then
	    upper = buf[next_pos]
	    lower = buf[next_pos + 1]
	  else
	    file.seek(next_pos, IO::SEEK_SET)
	    buf = file.read(2)
	    upper = buf[0] || 0
	    lower = buf[1] || 0
	  end
	  unless (Header::header?(upper, lower)) then
	    MPEGAudioStreamFile::mpeg_audio_error(@filename)
	  end

	  return pos
	end
      end

      # ヘッダが見つからなかった。
      MPEGAudioStreamFile::mpeg_audio_error(@filename)
    end
  end

  def self::mpeg_audio?(filename)
    mpeg = MPEGAudioStreamFile::new(filename)
    begin
      mpeg.read
    rescue NotMPEGAudioStreamError
      nil
    end
  end

  # get { ... }
  def get
    read unless @frame
    yield
  end
  private :get

  def version
    get{ @frame.version }
  end

  def version_num
    get{ @frame.version_num }
  end

  def layer
    get{ @frame.layer }
  end

  def layer_num
    get{ @frame.layer_num }
  end

  def error_protection
    get{ @frame.error_protection }
  end

  def bitrate
    get{ @frame.bitrate }
  end

  def sampling
    get{ @frame.sampling }
  end

  def mode
    get{ @frame.mode }
  end

  def mode_num
    get{ @frame.mode_num }
  end

  def copyright
    get{ @frame.copyright }
  end

  def original
    get{ @frame.original }
  end

  def frames
    get{ @frames }
  end

  def minutes
    get{ @minutes }
  end

  def remaining_seconds
    get{ @remaining_seconds }
  end

  def seconds
    get{ @seconds }
  end

  def file_size
    get{ @file_size }
  end
end

class MP3Tag
  def initialize(filename)
    # internal status
    @filename = filename
    @read_tag = false

    # basic tag information
    @title   = nil
    @artist  = nil
    @album   = nil
    @year    = nil
    @comment = nil
  end

  attr_reader :filename

  # NOTE: Return true if a file has a tag.
  def read_tag(file)
    raise NotImplementedError, "not defined: #{type}\#read_tag."
  end
  private :read_tag

  def write_tag(file)
    raise NotImplementedError, "not defined: #{type}\#write_tag."
  end
  private :write_tag

  def erase_tag(file)
    raise NotImplementedError, "not defined: #{type}\#erase_tag."
  end
  private :erase_tag

  def read
    File::open(@filename) do |file|
      @has_tag = read_tag(file)
      @read_tag = true
    end
    self
  end

  def write
    File::open(@filename, "r+") do |file|
      write_tag(file)
      @read_tag = true
      @has_tag = true
    end
    self
  end

  def erase
    File::open(@filename, "r+") do |file|
      read unless @read_tag
      if (@has_tag) then
	erase_tag(file)
      end
      @read_tag = true
      @has_tag = false
    end
    self
  end

  alias wipe erase

  # get{ ... }
  def get
    read unless @read_tag
    yield
  end
  private :get

  def has_tag?
    get{ @has_tag }
  end

  def self::has_tag?(filename)
    tag = self::new(filename)
    tag.has_tag?
  end

  def title
    get{ @title }
  end

  def title=(title)
    get{ @title = title }
  end

  def artist
    get{ @artist }
  end

  def artist=(artist)
    get{ @artist = artist }
  end

  def album
    get{ @album }
  end

  def album=(album)
    get{ @album = album }
  end

  def year
    get{ @year }
  end

  def year=(year)
    get{ @year = year }
  end

  def comment
    get{ @comment }
  end

  def comment=(comment)
    get{ @comment = comment }
  end

  def genre
    get{ @genre }
  end

  def genre=(genre)
    get{ @genre = genre }
  end

  class Loader
    def initialize(klass)
      @klass = klass
    end

    def load(filename)
      tag = @klass::new(filename)
      if (tag.has_tag?) then
	return tag
      end
      nil
    end
  end

  LOADER = []

  class << self
    def load(filename)
      LOADER.reverse_each do |loader|
	if (tag = loader.load(filename)) then
	  return tag
	end
      end

      nil
    end

    def add_loader(klass)
      LOADER.push(Loader::new(klass))
      self
    end

    def inherited(klass)
      add_loader(klass)
    end
  end
end

class ID3Tag < MP3Tag
  GENRE = [
    # 0
    "Blues", "Classic Rock", "Country", "Dance", "Disco",
    "Funk", "Grunge", "Hip-Hop", "Jazz", "Metal",
    # 10
    "New Age", "Oldies", "Other", "Pop", "R&B",
    "Rap", "Reggae", "Rock", "Techno", "Industrial",
    # 20
    "Alternative", "Ska", "Death Metal", "Pranks", "Soundtrack",
    "Euro-Techno", "Ambient", "Trip-Hop", "Vocal", "Jazz+Funk",
    # 30
    "Fusion", "Trance", "Classical", "Instrumental", "Acid",
    "House", "Game", "Sound Clip", "Gospel", "Noise",
    # 40
    "Alternative Rock", "Bass", "Soul", "Punk", "Space",
    "Meditative", "Instrumental Pop", "Instrumental Rock", "Ethnic", "Gothic",
    # 50
    "Darkwave", "Techno-Industrial", "Electronic", "Pop-Folk", "Eurodance",
    "Dream", "Southern Rock", "Comedy", "Cult", "Gangsta",
    # 60
    "Top 40", "Christian Rap", "Pop/Funk", "Jungle", "Native US",
    "Cabaret", "New Wave", "Psychadelic", "Rave", "Showtunes",
    # 70
    "Trailer", "Lo-Fi", "Tribal", "Acid Punk", "Acid Jazz",
    "Polka", "Retro", "Musical", "Rock & Roll", "Hard Rock",
    # 80
    "Folk", "Folk-Rock", "National Folk", "Swing", "Fast Fusion",
    "Bebob", "Latin", "Revival", "Celtic", "Bluegrass",
    # 90
    "Avantgarde", "Gothic Rock", "Progressive Rock", "Psychedelic Rock", "Symphonic Rock",
    "Slow Rock", "Big Band", "Chorus", "Easy Listening", "Acoustic",
    # 100
    "Humour", "Speech", "Chanson", "Opera", "Chamber Music",
    "Sonata", "Symphony", "Booty Bass", "Primus", "Porn Groove",
    # 110
    "Satire", "Slow Jam", "Club", "Tango", "Samba",
    "Folklore", "Ballad", "Power Ballad", "Rhytmic Soul", "Freestyle",
    # 120
    "Duet", "Punk Rock", "Drum Solo", "Acapella", "Euro-House",
    "Dance Hall", "Goa", "Drum & Bass", "Club-House", "Hardcore",
    # 130
    "Terror", "Indie", "BritPop", "Negerpunk", "Polsk Punk",
    "Beat", "Christian Gangsta Rap", "Heavy Metal", "Black Metal", "Crossover",
    # 140
    "Contemporary Christian", "Christian Rock", "Merengue", "Salsa", "Trash Metal",
    "Anime", "JPop", "SynthPop"
  ]

  GENRE_PATTERN = GENRE.collect{ |genre| /#{Regexp::quote(genre)}/i }

  TAG_SIZE = 128

  def initialize(*args)
    super
    @genre_num = nil
  end

  def test_read(file)
    file.seek(-TAG_SIZE, IO::SEEK_END)
    tag = file.read(TAG_SIZE).unpack("A3A30A30A30A4A30C")
    if (tag[0] == "TAG") then
      return tag
    end
    nil
  end
  private :test_read

  def read_tag(file)
    if (tag = test_read(file)) then
      @title     = tag[1]
      @artist    = tag[2]
      @album     = tag[3]
      @year      = tag[4]
      @comment   = tag[5]
      @genre_num = tag[6]
      @genre = GENRE[@genre_num]
      return true
    end
    false
  end
  private :read_tag

  def write_tag(file)
    tag = [
      "TAG",
      @title,
      @artist,
      @album,
      @year,
      @comment,
      @genre_num || 255
    ].pack("a3a30a30a30a4a30C")

    if (test_read(file)) then
      file.seek(-TAG_SIZE, IO::SEEK_END)
    else
      file.seek(0, IO::SEEK_END)
    end
    file.write(tag)
  end
  private :write_tag

  def erase_tag(file)
    if (read_test(file)) then
      file.truncate(file.stat.size - TAG_SIZE)
    end
  end
  private :erase_tag

  def genre=(genre)
    get do
      catch(:match_genre) do
	GENRE_PATTERN.each_with_index do |pattern, idx|
	  if (genre =~ pattern) then
	    @genre_num = idx
	    throw :match_genre
	  end
	end
	@genre_num = 255
      end
      @genre = genre
    end
  end

  def genre_num
    get{ @genre_num }
  end

  def genre_num=(genre_num)
    get do
      @genre = GENRE[genre_num]
      @genre_num = genre_num
    end
  end
end

class RIFF < MP3Tag
  # NOTE: Read only.

  TAG_MAP = {}
  [ 'INAM', 'IART', 'IPRD',
    'ICRD', 'ICMT', 'IGNR'
  ].each do |field|
    TAG_MAP[field] = true
  end

  def riff(file)
    # NOTE: based on Koga Atsushi <kog@ceres.dti.ne.jp> patch. Thanks!

    # search LIST chunk
    while ((chunk_head = file.read(8)) && chunk_head.length == 8)
      # search LIST chunk
      chunk_name, chunk_len = chunk_head.unpack('A4L')
      (chunk_name == 'LIST') and break
      (chunk_len % 2 != 0) and chunk_len += 1
      file.seek(chunk_len, IO::SEEK_CUR)
    end

    # skip INFO header
    if (file.eof? || file.read(4) != 'INFO') then
      return nil
    end

    # read SI fields
    tag = {}
    while ((si_head = file.read(8)) && si_head.length == 8)
      field, len = si_head.unpack('A4L')
      if (TAG_MAP.include? field) then
	fmt = "A#{len}"
	(len % 2 != 0) and len += 1
	(data = file.read(len)) && (data.length == len) or break
	data = data.unpack(fmt).first
	tag[field] = data
      end
    end

    tag
  end
  private :riff

  def read_tag(file)
    head, size, wave = file.read(12).unpack('A4LA4')
    if (head == 'RIFF') then
      tag = riff(file)
      @title   = tag['INAM']
      @artist  = tag['IART']
      @album   = tag['IPRD']
      @year    = tag['ICRD']
      @comment = tag['ICMT']
      @genre   = tag['IGNR']
      return true
    end
    false
  end
  private :read_tag
end
