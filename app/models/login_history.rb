# == Schema Information
# Schema version: 20
#
# Table name: login_histories
#
#  id          :integer       not null, primary key
#  user_id     :integer       
#  created_at  :datetime      
#  ip          :string(255)   
#  hostname    :string(255)   
#  system_info :string(255)   
#

# == Schema Information
# Schema version: 10
#
# Table name: login_histories
#
#  id          :integer(11)   not null, primary key
#  user_id     :integer(11)   
#  created_at  :datetime      
#  ip          :string(255)   
#  hostname    :string(255)   
#  system_info :string(255)   
#

class LoginHistory < ActiveRecord::Base
	belongs_to :user
end
