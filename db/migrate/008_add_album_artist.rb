class AddAlbumArtist < ActiveRecord::Migration
  def self.up
    add_column :tracks, :artist_id, :integer, :default=>nil
    add_column :tracks, :root, :string
    add_column :tracks, :relative_path, :string
    add_column :tracks, :filename, :string
    add_index :tracks, :root
    add_index :tracks, :relative_path
    add_index :tracks, :filename
    
    remove_index :tracks, :file
    remove_column :tracks, :file

    rename_column :albums, :various, :compilation
  end

  def self.down
    remove_column :tracks, :artist_id
    remove_column :tracks, :root
    remove_column :tracks, :relative_path
    remove_column :tracks, :filename

    rename_column :albums, :compilation, :various
  end
end
