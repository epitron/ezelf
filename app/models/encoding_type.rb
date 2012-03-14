# == Schema Information
# Schema version: 22
#
# Table name: encodings
#
#  id          :integer(4)    not null, primary key
#  name        :string(255)   
#  description :string(255)   
#

class EncodingType < ActiveRecord::Base
  set_table_name "encodings"
  has_many :sources
end
