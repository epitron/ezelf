class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
		t.column :name, :string
		t.column :albums_count, :integer, :default=>0
    end
	add_index :artists, :name
  end

  def self.down
    drop_table :artists
  end
end
