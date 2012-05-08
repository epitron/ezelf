class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.integer :album_id

      t.string :title, :string
      t.string :file, :string
      t.string :number, :limit=>10
      t.integer :disc
      t.integer :bitrate
      t.integer :length
      t.boolean :vbr
    end
    add_index :tracks, :title
    add_index :tracks, :file
    add_index :tracks, :album_id
    add_index :tracks, :number
  end

  def self.down
    drop_table :tracks
  end
end
