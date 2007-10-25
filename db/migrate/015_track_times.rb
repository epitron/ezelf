
class TrackTimes < ActiveRecord::Migration
  def self.up
  
	  add_column :tracks, :ctime, :datetime
	  add_column :tracks, :mtime, :datetime

    puts "-- setting times"

    for track in Track.find(:all)
      begin
        path = track.path
        track.ctime = path.ctime
        track.mtime = path.mtime
        track.save
      rescue Exception => e
        puts "Exception: #{e}"
      end
    end
    
  end

  def self.down
	  remove_column :tracks, :ctime
	  remove_column :tracks, :mtime
  end
end
