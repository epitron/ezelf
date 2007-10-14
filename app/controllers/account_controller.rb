class AccountController < ApplicationController


  skip_before_filter :login_required


  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end


  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    
    if logged_in?
      redirect_back_or_default(:controller=>'browse', :action=>'index')
      flash[:notice] = "Logged in successfully"
    end
    
  end


  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    flash[:notice] = "Thanks for signing up!"
    UserNotifier.deliver_signup_notification(@user)
    redirect_back_or_default(:controller => '')
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  
  def logout
    #self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '')
  end
  
  
  def activate
    @user = User.find_by_activation_code(params[:id])
    if @user and @user.activate
      self.current_user = @user
      flash[:notice] = "Your account has been activated." 
      UserNotifier.deliver_activation(@user)
      redirect_back_or_default(:controller => '')
    end
  end  

  
end
