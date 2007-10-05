class CreateSimilarArtists < ActiveRecord::Migration
  def self.up
    create_table :similar_artists do |t|
      t.column :artist_id, :integer
      t.column :similar_cache, :text
      t.column :updated_at, :datetime
    end
    add_index :similar_artists, :artist_id    
  end
  
  def self.down
    drop_table :similar_artists
  end
end
