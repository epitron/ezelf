# == Schema Information
# Schema version: 10
#
# Table name: users
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   
#  password   :string(255)   
#  fullname   :string(255)   
#  email      :string(255)   
#  created_at :string(255)   
#  validated  :boolean(1)    
#

class User < ActiveRecord::Base
	has_many :playlists
	has_many :logins, :class_name => 'LoginHistory'
	
	def last_login
		LoginHistory.find :first, :order=>"date desc"
	end
end
