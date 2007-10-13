class AddNewsTable < ActiveRecord::Migration
  def self.up
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
