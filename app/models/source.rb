# == Schema Information
# Schema version: 22
#
# Table name: sources
#
#  id          :integer(4)    not null, primary key
#  name        :string(255)   
#  description :string(255)   
#  uri         :string(255)   
#

require 'pathname'
require 'uri'
require 'audioinfo'

class Source < ActiveRecord::Base

  has_many :tracks
  has_many :albums
  belongs_to :encoding, :foreign_key => 'encoding_id', :class_name=>"EncodingType"

  
  URI_RECOGNIZER = %r{^(\w\{3-20\})://([^/]+)/.+}
  #has_many :albums, :through=>:tracks
  #has_many :artists, :through=>:albums

  
  def properly_encode_path(path)
    # http://www.gnu.org/software/libiconv/
    # Windows => "ISO-8859-1"
    from = encoding.name
    to = "UTF-8"

    if from and from != to
      Iconv.iconv(to, from, path)[0]
    else
      path
    end
  end

  
  def parse_uri
    uri = URI::parse(self.uri)
    uri.scheme # => "http"
    uri.host   # => "www.ruby-lang.org"

    # TODO: extend URI class for elf:// urls.
    #for URIHandler in HANDLERS
    #  return URIHandler.new(uri) if URIHandler.accepts(uri)
    #end
  end

  
  def uri?
    if uri =~ URI_RECOGNIZER
      true
    else
      false
    end
  end

  
  def dir?
    (not uri?) and File.directory?(uri)
  end

  
  def each_album(fast=false, &block)
    #path = rio(uri)
    paths = [Path[uri]].flatten
    
    p [:path, path]
    raise "can only scan dirs" unless path.dir?

    counter = 0
    path.ls.select(&:dir?).each do |dir|
      album = AudioInfo::Album.new(dir.path, fast)
      unless album.empty?
        album = AudioInfo::Album.new(dir.path, false) if album.va? and fast
        yield album
        counter += 1
      end
    end
    
    counter
    
  end
  
  
  def all_albums
    albums = []
    each_album { |album| albums << album }
    albums
  end
  
  
  def print_albums
    each_album do |album|
      album.print
    end
    nil
  end
  
  
  def import!
    each_album do |album|
      #=> test/albums/Whitey - The Light at the End of the Tunnel is a Train (2005)
      #          va?: false
      # guess_artist: Whitey
      #  guess_album: The Light At The End Of The Tunnel Is A Train
      #      discnum: 0
      #         path: test/albums/Whitey - The Light at the End of the Tunnel is a Train (2005)
      #         base: test/albums/Whitey - The Light at the End of the Tunnel is a Train (2005)
      # path->artist: Whitey
      #        empty: false
      #        files: 2
      #       images: Copy of folder.jpg, folder.jpg
      #      artists: ["Whitey"]
      #       albums: ["The Light At The End Of The Tunnel Is A Train"]
      #        years: ["2005"]

      # Artist
      n_artist = Artist.find_or_create_by_name(album.guess_artist)
      
      # Album
      discnum = (album.discnum == 0) ? nil : album.discnum
      n_album = n_artist.albums.find_or_create_by_name_and_year_and_discnum_and_source_id(album.guess_album, album.year, discnum, self.id)
      album.images.each { |image| n_album.images.create(:path=>image) }
      source_root = Pathname.new(self.uri)
      
      # Tracks
      album.files.each do |f|
        puts f.path
        p = Pathname.new(f.path)
        n_album.tracks.create(
          :title=>f.title,
          :number=>f.tracknum,
          :length=>f.length,
          :relative_path=>p.dirname.relative_path_from(source_root).to_s,
          :filename=>File.split(f.path).last,
          :bytes=>p.size,
          :ctime=>p.ctime,
          :mtime=>p.mtime,
          :source_id=>self.id
        )
      end
      
    end
  end
  
  
  def reinitialize!
    clear!
    import!
  end

  
  def clear!
    Track.delete_all(:source_id=>self.id)
    Album.delete_all(:source_id=>self.id)
  end
  
  
  ## MusicFolder interface...
  
#  def collect_music_folders(root=nil)
#    root ||= MusicFolder.new(uri)
#    
#    music_folders = []
#    for folder in root.folders
#    
#    # add self if it contains music
#    puts "+ #{folder}"
#    if folder.contains_music?
#      music_folders << folder
#    end
#    
#    # collect sub folders
#    music_folders += collect_music_folders(folder)
#    end
#    
#    music_folders
#  end
#
#  def merge_related_folders
#    # subfolders like CD1, CD2, etc. should be merged.
#  end
#  
#  def extract_compilations
#    # separate out directories that contain many random artists -- title it by folder name.
#    return albums, compilations
#  end
#  
end


class AudioInfo::Album
  
  def artist_from_path
    chunks = Pathname(path).split
    2.times do
      chunk = chunks.pop.to_s
      parts = chunk.split(/ - /)
      return case parts.size
        when 2
          parts[0]
        when 3
          parts[1]
        when 1
          parts[0]
      end
      next if discnum != 0
    end
    nil
  end
  
  def guess_artist
    if va? and squashed_artists.size < 2
      puts "  |_ WTF! va! and squashed_artists = #{squashed_artists.inspect}?"
    end
    
    return artist_from_path if squashed_artists.size > 1
    return artists.first
  end
  
  def guess_album
    if squashed_albums.size > 1
      puts "  |_ WTF! squashed_albums = #{squashed_albums.inspect}"
    end
    albums.first
  end
  
  def year
    years.first.blank? ? nil : years.first
  end
  
  def artists
    @artists ||= files.map(&:artist).compact.uniq
  end
  
  def albums
    @albums ||= files.map(&:album).compact.uniq
  end

  def years
    @years ||= files.map(&:year).compact.uniq
  end

  def squashed_artists
    @squashed_artists ||= artists.map(&:squash).map(&:downcase).uniq
  end
  
  def squashed_albums
    @squashed_albums ||= albums.map(&:squash).map(&:downcase).uniq
  end
  

  def print
    album = self
    puts "=> #{album.path}"
    puts "          va?: #{album.va?}"
    puts " guess_artist: #{album.guess_artist}"
    puts "  guess_album: #{album.guess_album}"
    puts "      discnum: #{album.discnum}"
    puts "         path: #{album.path}"
    puts "         base: #{album.basename}"
    puts " path->artist: #{artist_from_path}"
    puts "        empty: #{album.empty?}"
    puts "        files: #{album.files.size}"
    puts "       images: #{album.images.map{|f|rio(f).filename}.join(', ')}"
    puts "      artists: #{album.artists.inspect}"
    puts "       albums: #{album.albums.inspect}"
    puts "        years: #{album.years.inspect}"
    puts
  end
  
  
  
end

class String
  def squash
    gsub(/[\s']+/, '')
  end
end

## NOTE:
# Needs to recognize 3 styles of folders:
#     * Artist - Album/*.mp3
#     * Artist/{Album/*.mp3,*.mp3}
#     * 

  
#
#class MusicFolder < Pathname
#  alias_method :blank?, :size?
#  alias_method :dir?, :directory?
#  alias_method :folder?, :directory?
#
#  @@media_extensions = %w(.mp3 .ogg .m4a)
#
#  def dirs
#    @dir_cache ||= children.select{|e| e.directory? }
#  end
#  alias_method :folders, :dirs
#  
#  def files
#    @files_cache ||= children.select{|e| not e.track? }
#  end
#  
#  def tracks
#    @tracks_cache ||= children.select{|e| e.track? }
#  end
#  alias_method :mp3s, :tracks
#  
#  def track?
#    !dir? and @@media_extensions.include? extname
#  end
#  
#  def contains_music?
#    each_entry do |e|
#      return true if e.track?
#    end
#    return false
#  end
#  
#end
#


