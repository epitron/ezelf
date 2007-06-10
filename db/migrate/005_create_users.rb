class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :options=>'ENGINE=MyISAM' do |t|
		t.column :name, :string
		t.column :password, :string
		t.column :fullname, :string
		t.column :email, :string
		t.column :created_at, :string
    end
    add_index :users, :name
  end

  def self.down
    drop_table :users
  end
end
