#require 'rubygems'
require 'mp3info'
require 'iconv'

=begin
        # album_artist (:TPE2)
        #   - used by iTunes
        def album_artist()       frame_text(:TPE2) end
        def album_artist=(v) set_frame_text(:TPE2, v) end

        # composer (:TCOM)
        #   - used by EasyTag
        #   - used by Amarok
        def composer()       frame_text(:TCOM) end
        def composer=(v) set_frame_text(:TCOM, v) end

        # original_artist (:TOPE)
        #   - used by EasyTag
        def original_artist()       frame_text(:TOPE) end
        def original_artist=(v) set_frame_text(:TOPE, v) end
=end 
      
class ID3v2 
	
  ### Read a tag from file and perform UNICODE translation if needed
  def decode_tag(name, value)
    case name
      when "COMM"
        #FIXME improve this
        encoding, lang, str = value.unpack("ca3a*")
        out = value.split(0.chr).last
      else
        encoding = value[0]     # language encoding bit 0 for iso_8859_1, 1 for unicode
        out = value[1..-1]
    end

    if encoding == 1 #and name[0] == ?T
      #strip byte-order bytes at the beginning of the unicode string if they exists
      out[0..3] =~ /^[\xff\xfe]+$/ and out = out[2..-1]
      begin
        #out = Iconv.iconv("ISO-8859-1", "UNICODE", out)[0] 
        out = Iconv.iconv("ISO-8859-1", "UTF-16", out)[0] 
      rescue Iconv::IllegalSequence, Iconv::InvalidCharacter
      end
    end

    out
  end
  
end


class Mp3Info

  alias_method :real_initialize, :initialize

  def initialize(*args)
    real_initialize(*args)
    
    # strip nulls from strings
    things_to_fix = %w{@tag @tag_orig @tag1_orig @tag2 @tag1}
    
    for thingname in things_to_fix
      thing = instance_variable_get(thingname)
      for k in thing.keys
        thing[k].chomp!("\000") if thing[k].is_a? String
      end
    end
    
  end
  
end