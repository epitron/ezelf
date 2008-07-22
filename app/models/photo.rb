# == Schema Information
# Schema version: 20
#
# Table name: photos
#
#  id             :integer       not null, primary key
#  photoized_id   :integer       
#  photoized_type :string(255)   
#  path           :string(255)   
#  width          :integer       
#  height         :integer       
#  created_at     :datetime      
#  updated_at     :datetime      
#

class Photo < ActiveRecord::Base
end
