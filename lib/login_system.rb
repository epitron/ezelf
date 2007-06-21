require_dependency "user"

module LoginSystem 
  
protected

	# overwrite this if you want to restrict access to only a few actions
	# or if you want to check if the user has the correct rights  
	# example:
	#
	#  # only allow nonbobs
	#  def authorize?(user)
	#    user.login != "bob"
	#  end
	def authorized?(user, action)
		true
	end
	

	# overwrite this method if you only want to protect certain actions of the controller
	# example:
	# 
	#  # don't protect the login and the about method
	#  def protect?(action)
	#    if ['action', 'about'].include?(action)
	#       return false
	#    else
	#       return true
	#    end
	#  end
	def protect?(action)
		true
	end

	
	def logout!
		session[:user_id] = nil
		session[:state] = nil
	end
	
	
	# login_required filter. add 
	#
	#   before_filter :login_filter
	#
	# if the controller should be under any rights management. 
	# for finer access control you can overwrite
	#   
	#   def authorize?(user)
	# 
	def login_filter
		if not protect?( action_name )
			return true  
		end

		if not session[:user_id]
			# user isn't logged in
			store_location
			redirect_to :controller=>"account", :action=>"login"
			return false
		end

		# initialize the @user variable
		@user = User.find( session[:user_id] )
		
		if not @user.validated?
			# user is logged in, but they haven't been validated
			redirect_to :controller=>"account", :action=>"not_activated"
			return false
		elsif not authorized?( @user, action_name )
			# user is logged in and validated, but not authorized
			redirect_to :controller=>"account", :action =>"denied"
			return false
		else
			# user is logged in AND validated AND authorized! let 'em in!
			return true	
		end

		# we shouldn't get here
		raise "Serious malfunction in 'login_filter' -- please contact manufacturer (cgahan@ideeinc.com)..."
	end
	

	# store current uri in  the session.
	# we can return to this location by calling return_location
	def store_location
		session[:last_page] = @request.request_uri
	end
	

	# move to the last store_location call or to the passed default one
	def redirect_to_last_page
		if session[:last_page].nil?
			redirect_to '/'
		else
			redirect_to_url session[:last_page]
			session.delete :last_page
		end
	end


end