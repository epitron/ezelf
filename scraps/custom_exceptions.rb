class ApplicationController < ActionController::Base
 
 
  private  
 
    # Override exception handling to provide more information
    # in the log files.
    def rescue_action_locally(exception)
      cashboard_rescue_exception()
      super(exception)
    end
 
    def rescue_action_in_public(exception)
      cashboard_rescue_exception()
      super(exception)
    end
 
    # Adds extra shit to our error log so we can tell wtf
    # is going on when bad things happen.
    def cashboard_rescue_exception
      logger.error '^^^ CASHBOARD SPECIFIC INFO FOR ABOVE ERROR'
      logger.error '--------------------------------------------------------------------------------'
      begin
        logger.error "URL    : #{request.env['PATH_INFO']}"
        logger.error "BROWSER: #{request.env['HTTP_USER_AGENT']}"
        logger.error "IP ADDR: #{request.env['REMOTE_ADDR']}"
        # Try to find account if it's not set
        @account ||= Account.find_by_subdomain(account_subdomain)
        if @account
          logger.error "ACCOUNT: #{@account.subdomain}"
        end
        if @user
          logger.error "USER   : #{@user.inspect}\n"
        end
      rescue
        logger.error '...An error happend logging specific errors...wtf?'
      end
      logger.error '--------------------------------------------------------------------------------'
      logger.error ''
    end
 
end
