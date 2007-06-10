require File.dirname(__FILE__) + '/../test_helper'
require 'stream_controller'

# Re-raise errors caught by the controller.
class StreamController; def rescue_action(e) raise e end; end

class StreamControllerTest < Test::Unit::TestCase
  def setup
    @controller = StreamController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
