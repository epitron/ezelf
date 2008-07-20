# == Schema Information
# Schema version: 18
#
# Table name: sources
#
#  id          :integer(11)   not null, primary key
#  name        :string(255)   
#  description :string(255)   
#  uri         :string(255)   
#  encoding    :string(255)   
#

# == Schema Information
# Schema version: 10
#
# Table name: sources
#
#  id          :integer(11)   not null, primary key
#  name        :string(255)   
#  description :string(255)   
#  uri         :string(255)   
#

require 'pathname'
require 'uri'

class MusicFolder < Pathname
  alias_method :blank?, :size?
  alias_method :dir?, :directory?
  alias_method :folder?, :directory?

  @@media_extensions = %w(.mp3 .ogg .m4a)

  def dirs
    @dir_cache ||= children.select{|e| e.directory? }
  end
  alias_method :folders, :dirs
  
  def files
    @files_cache ||= children.select{|e| not e.track? }
  end
  
  def tracks
    @tracks_cache ||= children.select{|e| e.track? }
  end
  alias_method :mp3s, :tracks
  
  def track?
    !dir? and @@media_extensions.include? extname
  end
  
  def contains_music?
    each_entry do |e|
      return true if e.track?
    end
    return false
  end
  
end


class Source < ActiveRecord::Base
    has_many :tracks
    belongs_to :encoding
    
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
        #    return URIHandler.new(uri) if URIHandler.accepts(uri)
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


    ## MusicFolder interface...
    
    def collect_music_folders(root=nil)
      root ||= MusicFolder.new(uri)
      
      music_folders = []
      for folder in root.folders
        
        # add self if it contains music
        puts "+ #{folder}"
        if folder.contains_music?
          music_folders << folder
        end
        
        # collect sub folders
        music_folders += collect_music_folders(folder)
      end
      
      music_folders
    end

    def merge_related_folders
      # subfolders like CD1, CD2, etc. should be merged.
    end
    
    def extract_compilations
      # separate out directories that contain many random artists -- title it by folder name.
      return albums, compilations
    end
    
end


