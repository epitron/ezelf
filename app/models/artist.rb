class Artist < ActiveRecord::Base
	has_many :albums
	has_many :tracks, :through=>:albums
end
