class Mp3Info 
  module HashKeys #:nodoc:
    ### lets you specify hash["key"] as hash.key
    ### this came from CodingInRuby on RubyGarden
    ### http://www.rubygarden.org/ruby?CodingInRuby
    def method_missing(meth,*args)
      m = meth.id2name
      if /=$/ =~ m
	      self[m.chop] = (args.length<2 ? args[0] : args)
	    elsif /\?$/ =~ m
	      self[m.chop] != nil
      else
	      self[m]
      end
    end
  end

  module NumericBits #:nodoc:
    ### returns the selected bit range (b, a) as a number
    ### NOTE: b > a  if not, returns 0
    def bits(b, a)
      t = 0
      b.downto(a) { |i| t += t + self[i] }
      t
    end
  end

  module Mp3FileMethods #:nodoc:
    def get32bits
      (getc << 24) + (getc << 16) + (getc << 8) + getc
    end
    def get_syncsafe
      (getc << 21) + (getc << 14) + (getc << 7) + getc
    end
  end

end

class HashObject < Hash
  include Mp3Info::HashKeys
end

class Mp3FileObject < File
  include Mp3Info::Mp3FileMethods
end

Fixnum.class_eval { include Mp3Info::NumericBits }
Bignum.class_eval { include Mp3Info::NumericBits }
