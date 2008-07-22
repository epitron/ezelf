# == Schema Information
# Schema version: 20
#
# Table name: albums
#
#  id           :integer       not null, primary key
#  name         :string(255)   
#  artist_id    :integer       
#  year         :integer       
#  tracks_count :integer       default(0)
#  compilation  :boolean       
#  source_id    :integer       
#  updated_at   :datetime      
#  created_at   :datetime      
#

class Album < ActiveRecord::Base
    has_many :tracks #, :order => :number
    belongs_to :artist, :counter_cache => true
    has_many :photos, :as => :photoized

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

