class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums, :options=>'ENGINE=MyISAM' do |t|
		t.column :name, :string
		t.column :artist_id, :integer
		t.column :year, :integer
		t.column :tracks_count, :integer
		t.column :various, :boolean, :default=>false
    end
	add_index :albums, :artist_id
	add_index :albums, :name
  end

  def self.down
    drop_table :albums
  end
end
