# == Schema Information
# Schema version: 18
#
# Table name: albums
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  artist_id    :integer(11)   
#  year         :integer(11)   
#  tracks_count :integer(11)   default(0)
#  compilation  :boolean(1)    
#  updated_at   :datetime      
#  created_at   :datetime      
#

class Album < ActiveRecord::Base
    has_many :tracks #, :order => :number
    belongs_to :artist, :counter_cache => true

    def self.random(n)
      self.find :all, :limit=>n, :order=>"RAND()", :include=>:artist
    end

    def cover
      a = Scrobbler::Album.new(artist.name, name, :include_info => true)
      pp a      
    end

    def sorted_tracks
      tracks.sort_by{|track| track.number.to_i}
    end

    def nice_name
      title = name.blank? ? "Unkonwn" : name
      title += " (#{year})" if year
      title
    end
      
end

