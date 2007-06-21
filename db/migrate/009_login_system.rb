class LoginSystem < ActiveRecord::Migration
  def self.up
  	add_column :users, :validated, :boolean, :default=>false
  	rename_column :login_histories, :date, :created_at
  end

  def self.down
  	remove_column :users, :validated
  	rename_column :login_histories, :created_at, :date
  end
end
