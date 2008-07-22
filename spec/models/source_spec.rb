require "../spec_helper"

describe Source do

  before :each do
    @source = Source.new :uri=>"#{RAILS_ROOT}/test/albums"
  end
  
  context "path listings" do
    @source.scan_for_albums do |album|
      album
    end
  end
  
end
  
  