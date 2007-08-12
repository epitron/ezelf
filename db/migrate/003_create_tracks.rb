class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.column :title, :string
      t.column :file, :string
      t.column :album_id, :integer
      t.column :number, :integer
      t.column :disc, :integer
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
