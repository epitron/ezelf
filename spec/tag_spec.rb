require "spec_helper"

context Tag::FileInfo do

  before :each do
    @info = Tag::FileInfo.new "#{RAILS_ROOT}/test/test.mp3"
  end

  describe "gets info" do
    p @info.serialize
  end

end
  
