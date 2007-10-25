class FixTrackNum < ActiveRecord::Migration
  def self.up
	  change_column :tracks, :number, :string, :limit => 10
	
	  add_column :tracks, :length, :float
	  add_column :tracks, :bitrate, :integer
	  add_column :tracks, :vbr, :boolean
  end

  def self.down
	  change_column :tracks, :number, :integer

	  remove_column :tracks, :length
	  remove_column :tracks, :vbr
	  remove_column :tracks, :bitrate
  end
end
