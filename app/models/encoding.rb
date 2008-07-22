# == Schema Information
# Schema version: 20
#
# Table name: encodings
#
#  id          :integer       not null, primary key
#  name        :string(255)   
#  description :string(255)   
#

class Encoding < ActiveRecord::Base
  has_many :sources
end
