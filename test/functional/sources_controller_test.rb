require File.dirname(__FILE__) + '/../test_helper'
require 'sources_controller'

# Re-raise errors caught by the controller.
class SourcesController; def rescue_action(e) raise e end; end

class SourcesControllerTest < Test::Unit::TestCase
  def setup
    @controller = SourcesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
