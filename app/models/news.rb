# == Schema Information
# Schema version: 22
#
# Table name: news
#
#  id         :integer(4)    not null, primary key
#  title      :string(255)   
#  content    :string(255)   
#  summary    :string(255)   
#  user_id    :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#

class News < ActiveRecord::Base
  #order "created_at desc"  
end
