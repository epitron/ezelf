# == Schema Information
# Schema version: 10
#
# Table name: albums
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  artist_id    :integer(11)   
#  year         :integer(11)   
#  tracks_count :integer(11)   
#  compilation  :boolean(1)    
#

class Album < ActiveRecord::Base
    has_many :tracks, :order => :number
    belongs_to :artist, :counter_cache => true
end
