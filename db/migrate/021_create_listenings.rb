class CreateListenings < ActiveRecord::Migration
  def self.up
    create_table :listenings do |t|
      t.integer :user_id, :track_id
      t.datetime :started_at, :finished_at
    end
    
    add_index :listenings, :user_id
    add_index :listenings, :track_id
    add_index :listenings, :started_at
  end

  def self.down
    drop_table :listenings
  end
end
