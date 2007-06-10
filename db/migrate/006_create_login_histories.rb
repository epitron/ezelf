class CreateLoginHistories < ActiveRecord::Migration
  def self.up
    create_table :login_histories, :options=>'ENGINE=MyISAM' do |t|
    	t.column :user_id, :integer
    	t.column :date, :datetime
    	t.column :ip, :string
    	t.column :hostname, :string
    	t.column :system_info, :string
    end
    add_index :login_histories, :user_id
  end

  def self.down
    drop_table :login_histories
  end
end
