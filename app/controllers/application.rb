# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

=begin

::::::::::::::: request.env ::::::::::::::::::
Processing BrowseController#session_key (for 127.0.0.1 at 2007-06-13 05:30:28) [GET]
  Session ID: db9958cd64aa942578bd8e09366c296d
  Parameters: {"action"=>"session_key", "controller"=>"browse"}

{"SERVER_NAME"=>"localhost",
 "PATH_INFO"=>"/browse/session_key",
 "HTTP_TE"=>"deflate, gzip, chunked, identity, trailers",
 "HTTP_ACCEPT_ENCODING"=>"deflate, gzip, x-gzip, identity, *;q=0",
 "HTTP_USER_AGENT"=>"Opera/9.21 (X11; Linux i686; U; en)",
 "SCRIPT_NAME"=>"/",
 "SERVER_PROTOCOL"=>"HTTP/1.1",
 "HTTP_AUTHORIZATION"=>"Basic d2hhdDo=",
 "HTTP_ACCEPT_LANGUAGE"=>"en-US,en;q=0.9",
 "HTTP_HOST"=>"localhost:3000",
 "REMOTE_ADDR"=>"127.0.0.1",
 "SERVER_SOFTWARE"=>"Mongrel 1.0.1",
 "REQUEST_PATH"=>"/browse/session_key",
 "HTTP_COOKIE2"=>"$Version=1",
 "HTTP_COOKIE"=>"_ezelf_session_id=db9958cd64aa942578bd8e09366c296d",
 "HTTP_ACCEPT_CHARSET"=>"iso-8859-1, utf-8, utf-16, *;q=0.1",
 "HTTP_VERSION"=>"HTTP/1.1",
 "REQUEST_URI"=>"/browse/session_key",
 "SERVER_PORT"=>"3000",
 "GATEWAY_INTERFACE"=>"CGI/1.2",
 "HTTP_ACCEPT"=>
  "text/html, application/xml;q=0.9, application/xhtml+xml, image/png, image/jpeg, image/gif, image/x-xbitmap, */*;q=0.1",
 "HTTP_CONNECTION"=>"Keep-Alive, TE",
 "REQUEST_METHOD"=>"GET"}

=end

class ApplicationController < ActionController::Base

  include AuthenticatedSystem
  before_filter :login_required
  
  # use this for "remember me"
  #before_filter :login_from_cookie
  
  #session :session_key => '_ezelf_session_id'

  if true #SETTINGS.disable_authentication
    def login_filter
      unless session[:user_id]
        session[:user_id] = 0
        begin
          @user = User.find(0)
        rescue
          @user = User.new(:name=>"anonymous")
        end
      end
      return true
    end
  end

  #before_filter :session_from_params
  #before_filter :login_filter
  #before_filter :show_env

  def session_from_params; end

  def show_env
    puts ":::::::::::::::Env::::::::::::::::::"
    pp request.env
    puts
    # if an HTTPAuth username is supplied, use it as a "User Key" and find the user's session.
  end

end
