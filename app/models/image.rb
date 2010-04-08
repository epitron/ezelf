# == Schema Information
# Schema version: 22
#
# Table name: images
#
#  id          :integer(4)    not null, primary key
#  imaged_id   :integer(4)    
#  imaged_type :string(255)   
#  path        :string(255)   
#  width       :integer(4)    
#  height      :integer(4)    
#  created_at  :datetime      
#  updated_at  :datetime      
#

class Image < ActiveRecord::Base
end
