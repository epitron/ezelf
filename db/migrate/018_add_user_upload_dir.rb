class AddUserUploadDir < ActiveRecord::Migration
  def self.up
    add_column :users, :upload_dir, :string
  end

  def self.down
    remove_column :users, :upload_dir
  end
end
