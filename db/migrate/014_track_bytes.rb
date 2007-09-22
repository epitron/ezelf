class TrackBytes < ActiveRecord::Migration
  def self.up
	add_column :tracks, :bytes, :integer

        puts "-- setting file sizes"

        for track in Track.find(:all)
          begin
            track.bytes = File.size track.fullpath
            track.save
          rescue Exception => e
            puts "Exception: #{e}"
          end
        end
  end

  def self.down
	remove_column :tracks, :bytes
  end
end
