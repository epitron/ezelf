class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.column :name, :string
      t.column :description, :string
      t.column :uri, :string
    end

    add_column :tracks, :source_id, :integer
    remove_index :tracks, :root
    remove_column :tracks, :root
    add_index :tracks, :source_id
  end

  def self.down
    drop_table :sources
    remove_column :tracks, :source_id
    add_column :tracks, :root, :string
  end
end
