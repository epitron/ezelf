# == Schema Information
# Schema version: 15
#
# Table name: albums
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  artist_id    :integer(11)   
#  year         :integer(11)   
#  tracks_count :integer(11)   
#  compilation  :boolean(1)    
#  updated_at   :datetime      
#  created_at   :datetime      
#

class Album < ActiveRecord::Base
    has_many :tracks #, :order => :number
    belongs_to :artist, :counter_cache => true

    def cover
      a = Scrobbler::Album.new(artist.name, name, :include_info => true)
      pp a      
    end

    def sorted_tracks
      tracks.sort_by{|track| track.number.to_i}
    end
end

