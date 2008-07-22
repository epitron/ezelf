# == Schema Information
# Schema version: 20
#
# Table name: tracks
#
#  id            :integer       not null, primary key
#  title         :string(255)   
#  album_id      :integer       
#  number        :string(10)    
#  disc          :integer       
#  artist_id     :integer       
#  relative_path :string(255)   
#  filename      :string(255)   
#  source_id     :integer       
#  length        :float         
#  bitrate       :integer       
#  vbr           :boolean       
#  updated_at    :datetime      
#  created_at    :datetime      
#  bytes         :integer       
#  ctime         :datetime      
#  mtime         :datetime      
#

# http://id3lib-ruby.rubyforge.org/doc/index.html
# http://ruby-mp3info.rubyforge.org/

require 'mp3info_with_extensions'
require 'pathname'

class Track < ActiveRecord::Base

  belongs_to :album, :counter_cache => true
  belongs_to :artist, :counter_cache => true
  belongs_to :source
  
  belongs_to :folder
 
  before_save :set_defaults

  def set_defaults
    self.mtime = path.mtime unless mtime
    self.ctime = path.mtime unless ctime
    self.bytes = path.size unless bytes
  end

  alias_method :track_artist, :artist

  def artist
    @attributes[:artist] || (album && album.artist)
  end

  def dirs
    @cached_dirs ||= relative_path.split '/'
  end

  def path
    Pathname.new( fullpath )
  end

  def fullpath
    File.join( source.uri, relative_path, filename )
  end

  def title
    attributes['title'] || 'Unknown'
  end

  def modified?
    (mtime && path.mtime > mtime) || path.size != bytes
  end

  def self.all
    Track.find_by_sql("SELECT * FROM artists,albums,tracks WHERE tracks.album_id = albums.id AND albums.artist_id = artists.id ORDER BY artists.name,albums.name,tracks.number")
  end

  def self.format_tracknum(num)
    num.to_s.gsub(/\d+/) {|m| "%0.2d" % m }
  end
  
  def self.my_findorcreate(model, fields)
    if obj = model.find( :first, :conditions=>fields )
      obj
    else
      model.create fields
    end
  end
  
  
  def self.add_file( source, path_and_filename )
  
    # BUG: Albums with > 1 artist get associated with the last artist.
    # |_ to fix, put all Tag's in an array keyed by album, and mark ones 
    # |    with > 1 artist as "various".
    # |_ support "Album Artist" tag (TPE2)

    root = source.uri
    fullpath = File.join( root, path_and_filename )
    relative_path, filename = File.split(path_and_filename)
    bytes = File.size fullpath

    if track = Track.find(:first, :conditions => {:source_id=>source.id, :relative_path=>relative_path, :filename=>filename})
      #puts "- #{track.filename} already in db..."
      if track.modified?
        puts " *** track modified! ***"
        track.destroy
      else
        return 
      end
    end

    mp3 = Mp3Info::new(fullpath)
    tag = mp3.tag

    unless Artist.find :first, :conditions=>{:name=>tag.artist}
      puts "  *** NEW artist ***"
    end

    # find/create track, album, and artist

    track   = Track.find_or_create_by_source_id_and_relative_path_and_filename(
                source.id, 
                relative_path, 
                filename
              )
    album   = Album.find_or_create_by_name(tag.album)
    artist  = Artist.find_or_create_by_name(tag.artist)

=begin
    track = my_findorcreate(
      Track,
      :source_id=>source.id, 
      :relative_path=>relative_path, 
      :filename=>filename
    )
    album   = my_findorcreate Album, :name=>tag.album
    artist  = my_findorcreate Artist, :name=>tag.artist
=end

    # use tag.album_artist to figure out if this is a compilation
    album_has_a_different_artist_already = (album.artist and album.artist != artist)
    album_artist_tag_is_different_from_artist_tag = (tag.album_artist and tag.album_artist != tag.artist)
    if album_has_a_different_artist_already or album_artist_tag_is_different_from_artist_tag
      # this is a compilation!

      if tag.album_artist
        # album_artist (eg: 2 Many DJs)
        album_artist = Artist.find_or_create_by_name(tag.album_artist)
      else
        # no album_artist (eg: Various Artists)
        album_artist = Artist.find_or_create_by_name('Various Artists')
      end
      
      # link album
      album_artist.albums << album
      
      # link track to artist and album
      artist.compilation_tracks << track
      album.tracks << track
      album.compilation = true
      
    else
      ## Single Artist
      album.tracks  << track  # track goes in album
      artist.albums << album  # album goes in artist
    end

    track.title         = tag.title
    track.bytes         = bytes
    track.number        = format_tracknum(tag.tracknum)
    track.relative_path = source.properly_encode_path(relative_path)
    track.filename      = source.properly_encode_path(filename)
    track.bitrate       = mp3.bitrate
    track.length        = mp3.length
    track.vbr           = mp3.vbr

    album.year		= tag.year if tag.year && tag.year.to_i > 0

    track.save
    album.save
    artist.save

    return track
  end

  class TreeNode
    attr_accessor :parent, :node, :children
    def initialize(parent, node, children=[])
      @parent = parent
      @node = node
      @children = children
    end
  end

  def directory_tree(root)
    tree = {}
    Pathname.new(root).entries.each do |entry|
      case entry
      when entry.directory?
        puts "directory: #{entry}"
        tree[entry] = directory_tree(entry)
      when entry.file?
        puts "file: #{entry}"
        tree[entry] = 0
      end
    end
    tree
  end

end

