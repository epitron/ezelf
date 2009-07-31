class AdminController < ApplicationController
  include Clearance::Authentication
  #layout "admin"
  #before_filter :administrators_only!

protected
  def administrators_only!
    #current_user.admin?
  end

end