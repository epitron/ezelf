require File.dirname(__FILE__) + '/../test_helper'
require 'account_controller'

# Re-raise errors caught by the controller.
class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < Test::Unit::TestCase
  def setup
    @controller = AccountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_confirms_password
    get :signup, :user=>{:name=>"stew", :password=>"woot", :password_confirmation=>"woot", :email=>"stew@awesome.com"}
    assert @user.errors.empty?
  end
end
