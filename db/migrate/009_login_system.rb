class LoginSystem < ActiveRecord::Migration
  def self.up
  	add_column :users, :enabled, :boolean, :default=>false
  	rename_column :login_histories, :date, :created_at
  end

  def self.down
  	remove_column :users, :enabled
  	rename_column :login_histories, :created_at, :date
  end
end
