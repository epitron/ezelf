class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
		t.column :name, :string
		t.column :password, :string
		t.column :fullname, :string
		t.column :email, :string
		t.column :created_at, :string
    end
    add_index :users, :name

	User.create :name=>"admin", :password=>"crinkle", :fullname=>"Mr. Administrator", :email=>"nobody@nowhere.com"
  end

  def self.down
    drop_table :users
  end
end
