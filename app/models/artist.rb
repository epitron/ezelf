# == Schema Information
# Schema version: 10
#
# Table name: artists
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  albums_count :integer(11)   
#

class Artist < ActiveRecord::Base
	has_many :albums
	has_many :album_tracks, :through => :albums, :source => :tracks, :order => :number
	has_many :compilation_tracks, :class_name => "Track", :order => :number
	
	def tracks
		album_tracks + compilation_tracks
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
