class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :imaged_id
      t.string :imaged_type
      
      t.string :path
      
      t.integer :width
      t.integer :height
      
      t.timestamps
    end
    
    add_index :listened_tracks, [:imaged_id, :imaged_type]
  end

  def self.down
    drop_table :images
  end
end
