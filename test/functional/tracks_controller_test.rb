require File.dirname(__FILE__) + '/../test_helper'
require 'tracks_controller'

# Re-raise errors caught by the controller.
class TracksController; def rescue_action(e) raise e end; end

class TracksControllerTest < Test::Unit::TestCase
  def setup
    @controller = TracksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
