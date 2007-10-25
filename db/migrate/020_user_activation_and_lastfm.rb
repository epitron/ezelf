class UserActivationAndLastfm < ActiveRecord::Migration
  def self.up
    add_column :users, :activation_code, :string, :limit => 40
    add_column :users, :activated_at, :datetime    
    
    add_column :users, :lastfm_login, :string
    add_column :users, :lastfm_password, :string
  end

  def self.down
    remove_column :users, :activation_code
    remove_column :users, :activated_at
    
    remove_column :users, :lastfm_login
    remove_column :users, :lastfm_password
  end
end
