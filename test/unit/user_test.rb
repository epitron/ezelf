require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def test_uniqueness
    assert User.find_by_name("existy") == nil
    u1 = User.create :name=>"existy", :password=>"existify!"
    u2 = User.create :name=>"existy", :password=>"asdfasd"
    assert_not u1.errors.any?
    assert u2.errors.any?
  end
  def test_password_confirmation
    u = User.create :name=>"testy", :password=>"testifiy!"
  end
  
  def test_create_from_console
    u = User.create :name=>"testy", :password=>"testifiy!"
    assert u
  end
  
end
