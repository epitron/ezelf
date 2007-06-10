require File.dirname(__FILE__) + '/../test_helper'

class TrackTest < Test::Unit::TestCase
	fixtures :tracks
	
	# Replace this with your real tests.
	def test_truth
		assert true
	end
	
	def test_add_file
		testmp3 = File.dirname(__FILE__) + "/../test.mp3" 
		newtrack = Track.add_file testmp3
		assert newtrack.artist == "Bis"
		assert newtrack.album == "Music for a Stranger World"
		assert newtrack.track == "Music for a Stranger World"
	end
  	
end
