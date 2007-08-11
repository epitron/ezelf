class CreateAlbums < ActiveRecord::Migration
  def self.up
	puts "Setting UTF8..."
  	execute "ALTER DATABASE #{current_database} DEFAULT CHARACTER SET utf8"

    create_table :albums, :options=>'ENGINE=MyISAM' do |t|
		t.column :name, :string
		t.column :artist_id, :integer
		t.column :year, :integer
		t.column :tracks_count, :integer, :default=>0
		t.column :various, :boolean, :default=>false
    end
	add_index :albums, :artist_id
	add_index :albums, :name
  end

  def self.down
    drop_table :albums
  end
end
