$: << File.join( File.dirname(__FILE__), "../lib" )

require 'mp3info_with_extensions'
require 'ruby-debug'

describe "MP3Info Module" do
  it "should not have nulls at the end of tags" do
    debugger
    mp3 = Mp3Info::new('nulls.mp3')
    mp3.tag["artist"][-1].should_not equal 0
  end
end
