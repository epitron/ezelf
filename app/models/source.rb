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


require 'uri'

class Source < ActiveRecord::Base
    has_many :tracks
    
    URI_RECOGNIZER = %r{^(\w\{3-20\})://([^/]+)/.+}
    #has_many :albums, :through=>:tracks
    #has_many :artists, :through=>:albums

    def properly_encode_path(path)
    	# http://www.gnu.org/software/libiconv/
    	# Windows => "ISO-8859-1"
    	if encoding
    		Iconv.iconv("UTF-8", encoding, path)[0]
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
		#	return URIHandler.new(uri) if URIHandler.accepts(uri)
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
    
end
