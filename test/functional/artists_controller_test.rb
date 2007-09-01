require File.dirname(__FILE__) + '/../test_helper'
require 'artists_controller'

# Re-raise errors caught by the controller.
class ArtistsController; def rescue_action(e) raise e end; end

class ArtistsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ArtistsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
