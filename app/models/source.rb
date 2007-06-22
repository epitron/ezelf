class Source < ActiveRecord::Base
    has_many :tracks
    #has_many :albums, :through=>:tracks
    #has_many :artists, :through=>:albums

    def uri?
        if uri =~ %r{^(\w\{3-10\})://([^/]+)/.+}
            true
        else
            false
        end
    end

    def dir?
        (not uri?) and File.directory?(uri)
    end

end
