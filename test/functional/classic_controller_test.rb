require File.dirname(__FILE__) + '/../test_helper'
require 'classic_controller'

# Re-raise errors caught by the controller.
class ClassicController; def rescue_action(e) raise e end; end

class ClassicControllerTest < Test::Unit::TestCase
  def setup
    @controller = ClassicController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
