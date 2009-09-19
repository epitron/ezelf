class AccountController < ApplicationController
	#model   :user
	layout  'login', :except=>:login
	
	skip_before_filter :login_filter
	
	def index
		redirect_to :action=>"login"
	end

	
  	def login
		case request.method
			when :post
				if @user = User.find( :first, :conditions=>{ :name => params[:user][:name], :password => params[:user_password]} )

					# log login
					@user.login_history.create 	:ip=>request.env["REMOTE_ADDR"], 
												:system_info=>request.env["HTTP_USER_AGENT"]
					
					session[:user_id] = @user.id

					redirect_to_last_page
				else
					#@user    = params[:user]
					flash[:notice]  = "BZZZZZT!"
				end
		end
	end


	def signup
		case request.method
			when :post
				@new_user = User.create(params[:new_user])
				
				if @new_user.valid?
					begin 
						Notifier.deliver_user_added( @new_user )
					rescue Net::SMTPFatalError
						logger.error "Error delivering mail (user added: #{@new_user.inspect})"
					end
					
					log_action 0, "created an account", false, @user
					
					redirect_to :action => "signup_successful"          
				end
			when :get
				@new_user = User.new
		end      
	end  

	def signup_successful
	end

	def logout
		#log_action 0, "logout", false
		logout!
		redirect_to :action=>"login"
	end
	

	def denied
		if @user and @user.validated?
			redirect_to_last_page
		end
	end

	def not_activated
		logout!
	end
  

	def forgot_password
	end
	

	def reset_password
	end
  
	
end
