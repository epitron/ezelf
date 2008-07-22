# == Schema Information
# Schema version: 20
#
# Table name: images
#
#  id          :integer       not null, primary key
#  imaged_id   :integer       
#  imaged_type :string(255)   
#  path        :string(255)   
#  width       :integer       
#  height      :integer       
#  created_at  :datetime      
#  updated_at  :datetime      
#

class Image < ActiveRecord::Base
end
