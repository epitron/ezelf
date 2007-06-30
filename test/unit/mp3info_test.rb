#require File.dirname(__FILE__) + '/../test_helper'
require 'rubygems'
require 'mp3info'
require 'test/unit'

class Mp3InfoTest < Test::Unit::TestCase
	#fixtures :tracks

	def setup
		testmp3 = File.dirname(__FILE__) + "/../test.mp3" 
		@mp3 = Mp3Info::new testmp3
		@tag = @mp3.tag
	end		
	
	def test_data
		assert_equal "Bis", @tag.artist
		assert_equal "Music For A Stranger World", @tag.album
		assert_equal "Dead Wrestlers", @tag.title
	end
  	
	def test_time_and_bitrate
		assert_equal 128, @mp3.bitrate
		assert_equal 227, @mp3.length.to_i
		assert_equal false, @mp3.vbr
	end
	
end
