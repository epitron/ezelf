# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

=begin
{"SERVER_NAME"=>"localhost",
 "PATH_INFO"=>"/stream/track/177.mp3",
 "HTTP_USER_AGENT"=>
  "curl/7.15.4 (i686-pc-cygwin) libcurl/7.15.4 OpenSSL/0.9.8e zlib/1.2.3",
 "SCRIPT_NAME"=>"/",
 "SERVER_PROTOCOL"=>"HTTP/1.1",
 "HTTP_HOST"=>"localhost:3000",
 "REMOTE_ADDR"=>"127.0.0.1",
 "SERVER_SOFTWARE"=>"Mongrel 1.0.1",
 "REQUEST_PATH"=>"/stream/track/177.mp3",
 "HTTP_CONTENT_RANGE"=>"bytes 5000-/-1",
 "HTTP_VERSION"=>"HTTP/1.1",
 "REQUEST_URI"=>"/stream/track/177.mp3",
 "SERVER_PORT"=>"3000",
 "GATEWAY_INTERFACE"=>"CGI/1.2",
 "HTTP_ACCEPT"=>"*/*",
 "REQUEST_METHOD"=>"HEAD"}
=end

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_ezelf_session_id'
  
end
