class AddNewsTable < ActiveRecord::Migration
  def self.up
    
    add_column :users, :activation_code, :string, :limit => 40
    add_column :users, :activated_at, :datetime    
    
    add_column :users, :lastfm_login, :string
    add_column :users, :lastfm_password, :string
    
    
    create_table :news do |t|
      t.column :title, :string
      t.column :body, :text
      t.column :format, :string
      t.column :created_by, :integer
      t.column :created_at, :datetime
    end
    add_index :news, :created_at
  end

  def self.down
    drop_table :news
  end
end
