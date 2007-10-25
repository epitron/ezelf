class CountsAndTimestamps < ActiveRecord::Migration

  def self.up
  
  	add_column :artists, :tracks_count, :integer
    add_column :artists, :updated_at, :datetime
    add_column :artists, :created_at, :datetime

    add_column :albums, :updated_at, :datetime
    add_column :albums, :created_at, :datetime

    add_column :tracks, :updated_at, :datetime
    add_column :tracks, :created_at, :datetime

    add_index :tracks, :updated_at
    add_index :albums, :updated_at
    add_index :artists, :updated_at

	  for artist in Artist.find :all
      artist.tracks_count = artist.tracks.size
      artist.save
    end        
    
  end

  def self.down
	  remove_column :artists, :tracks_count
	  remove_column :artists, :created_at
	  remove_column :artists, :updated_at

	  remove_column :albums, :updated_at
	  remove_column :albums, :created_at

	  remove_column :tracks, :created_at
	  remove_column :tracks, :updated_at
  end
  
end
