require File.dirname(__FILE__) + '/../spec_helper'

describe Source do

  before :each do
    @source = Source.new :uri=>"#{RAILS_ROOT}/test/albums"
  end

  it "guess_album_artist should use directories" do
    a = AudioInfo::Album.new("/home/chris/ezelf/test/albums/MSTRKRFT - Remixes to Date (2006)", false)
    a.guess_artist.should == "MSTRKRFT"
  end
  
end
  
  