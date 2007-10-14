class UsersController < ApplicationController
	layout 'streamlined'
	acts_as_streamlined
	
  def authorized?
    current_user.login.match /^(epi|admin)$/
  end

end
