class CreateAlbums < ActiveRecord::Migration
  
  def self.up
    
    puts "Setting UTF8..."
    
    case adapter_name
      when "SQLite"
        execute "PRAGMA encoding = 'UTF-8'"
      when "MySQL"
        execute "ALTER DATABASE #{current_database} DEFAULT CHARACTER SET utf8"
        execute "SET storage_engine=MYISAM"
    end

    create_table :albums do |t|
      t.column :name, :string
      t.column :artist_id, :integer
      t.column :year, :integer
      t.column :tracks_count, :integer, :default=>0
      t.column :various, :boolean, :default=>false
      t.integer :source_id
    end
    
    add_index :albums, :artist_id
    add_index :albums, :name
    
  end

  def self.down
    drop_table :albums
  end
end
