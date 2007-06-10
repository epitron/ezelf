class User < ActiveRecord::Base
	has_many :playlists
	has_many :logins #, :class => 'LoginHistory'
end
