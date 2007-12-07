require 'rubygems'
require 'id3lib'

module Tag

  class FileInfo
    def self.new(filename)
      @filename = filename
      self.load(filename)
    end
    
    def to_info
      raise NotImplementedError
    end
    
    def serialize
      raise NotImplementedError
    end
    
  end

  class MP3File < FileInfo

    def self.load(filename)
      @tag = ID3::Tag.new(filename)    
    end
    
    def serialize
      #=> {:id => :TIT2, :text => "Shy Boy", :textenc => 0}
      #=> {:id => :TPE1, :text => "Katie Melua", :textenc => 0}
      #=> {:id => :TALB, :text => "Piece By Piece", :textenc => 0}
      #=> {:id => :TRCK, :text => "1/12", :textenc => 0}
      #=> {:id => :TYER, :text => "2005", :textenc => 0}
      #=> {:id => :TCON, :text => "Jazz/Blues", :textenc => 0}
      Hash.new @tag.map{|frame| [frame[:id], frame.reject{|k,v| k == :id}]}.flatten
    end

  end
  
end
