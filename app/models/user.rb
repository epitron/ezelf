class User < ActiveRecord::Base
	has_many :playlists
	has_many :logins, :class_name => 'LoginHistory'
	
	def last_login
		LoginHistory.find :first, :order=>"date desc"
	end
	
	
end
