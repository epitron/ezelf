class AddSourceEncoding < ActiveRecord::Migration
  def self.up
    add_column :sources, :encoding, :string
  end

  def self.down
    remove_column :sources, :encoding
  end
end
