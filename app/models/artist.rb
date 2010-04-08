# == Schema Information
# Schema version: 22
#
# Table name: artists
#
#  id           :integer(4)    not null, primary key
#  name         :string(255)   
#  albums_count :integer(4)    default(0)
#  tracks_count :integer(4)    
#  updated_at   :datetime      
#  created_at   :datetime      
#

require 'scrobbler'

class Artist < ActiveRecord::Base
  
  has_many :albums
  
  has_many :album_tracks, 
           :through => :albums, 
           :source => :tracks #, :order => :number
           
  has_many :compilation_tracks, 
           :class_name => "Track" #, :order => :number

  has_many :images, :as => :imaged
  
  def tracks
    album_tracks + compilation_tracks
  end

  def similar
    similar_artists = SimilarArtists.find_or_create_by_artist_id(self.id)          
    similar_artists.similar
  end
           
end

=begin
 has_many :comments, :order => "posted_on"
  has_many :comments, :include => :author
  has_many :people, :class_name => "Person", :conditions => "deleted = 0", :order => "name"
  has_many :tracks, :order => "position", :dependent => :destroy
  has_many :comments, :dependent => :nullify
  has_many :tags, :as => :taggable
  has_many :subscribers, :through => :subscriptions, :source => :user
  has_many :subscribers, :class_name => "Person", :finder_sql =>
      'SELECT DISTINCT people.* ' +
      'FROM people p, post_subscriptions ps ' +
      'WHERE ps.post_id = #{id} AND ps.person_id = p.id ' +
      'ORDER BY p.first_name'
=end

