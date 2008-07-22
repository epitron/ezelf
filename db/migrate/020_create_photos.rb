class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :photoized_id
      t.string :photoized_type
      
      t.string :path
      
      t.integer :width
      t.integer :height
      
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
