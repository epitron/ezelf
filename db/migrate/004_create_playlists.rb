class CreatePlaylists < ActiveRecord::Migration
  def self.up
    create_table :playlists do |t|
		t.column :name, :string
		t.column :user_id, :integer
    end
	add_index :playlists, :user_id
    
    create_table :playlists_tracks, :id=>false do |t|
		t.column :playlist_id, :integer
		t.column :track_id, :integer
    end
	add_index :playlists_tracks, :track_id
	add_index :playlists_tracks, :playlist_id
    
  end

  def self.down
    drop_table :playlists
    drop_table :playlists_tracks
  end
end
