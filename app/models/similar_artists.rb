# == Schema Information
# Schema version: 20
#
# Table name: similar_artists
#
#  id            :integer       not null, primary key
#  artist_id     :integer       
#  similar_cache :text          
#  updated_at    :datetime      
#

class SimilarArtists < ActiveRecord::Base
  belongs_to :artist
  serialize :similar_cache

  def similar
    if similar_cache.nil? or updated_at < 10.minutes.ago
      a = Scrobbler::Artist.new(artist.name)
      self.similar_cache = a.similar
      self.save
    end
    self.similar_cache
  end
end
