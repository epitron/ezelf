class UserNotifier < ActionMailer::Base
  
  def signup_notification(user)
    setup_email(user)
    @subject    += 'ELFTIVATION PROTOCOL: Phase 1'
    @body[:url]  = "http://elf.kicks-ass.net/account/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'ELFTIVATION SUCCESSFUL.'
    @body[:url]  = "http://elf.kicks-ass.net/"
  end
  
protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "headELF@elf.kicks-ass.net"
    @subject     = ""
    @sent_on     = Time.now
    @body[:user] = user
  end
end
