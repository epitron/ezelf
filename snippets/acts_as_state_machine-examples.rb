# Acts As State Machine Examples
#
# Of note:
#  * For every 'state' you define, a query method <state>? is created
#  * For every 'event' you define, a method <event>! is created
#  * Entry, exit, and guard actions can be defined either as a Proc object or
#    as a symbol.  The symbol should be the name of an instance method on the 
#    model.


# A simple transition
#
#  +---------+   run   +---------+
#  | idle    |-------->| running |
#  +---------+         +---------+
#
class Machine < ActiveRecord::Base
  acts_as_state_machine :initial => :idle
  
  state :idle
  state :running
  
  event :run do
    transitions :from => :idle, :to => :running
  end
end


# A loopback transition
#  +---------+
#  |         |------+
#  | idle    |      | timeout
#  |         |<-----+
#  +---------+
#
class Machine < ActiveRecord::Base
  acts_as_state_machine :initial => :idle
  
  state :idle
  
  event :timeout do
    transitions :from => :idle, :to => :idle
  end
end


# A transition with enter and exit actions
#  +---------+               +---------+
#  |         |     run       |         |
#  | idle    |-------------->| running |
#  |         |   stop_timer  |         |
#  +---------+   do_work     +---------+
#
class Machine < ActiveRecord::Base
  acts_as_state_machine :initial => :idle
  
  state :idle
  state :running, :enter => Proc.new { |o| o.stop_timer('idle'); o.do_work() },
                  :exit  => :exit_running
  
  event :run do
    transitions :from => :idle, :to => :running
  end
  
  def stop_timer(timer)
  end
  
  def do_work
  end

  def exit_running
  end
end


# Transition guards
#  +---------+               +---------+
#  |         |     run[t]    |         |
#  | idle    |-------------->| running |
#  |         |   stop_timer  |         |
#  +---------+   do_work     +---------+
#    |     ^
#    |     |
#    +_____+
#     run[f]
#
class Machine < ActiveRecord::Base
  acts_as_state_machine :initial => :idle
  
  state :idle
  state :running, :enter => Proc.new { |o| o.stop_timer('idle'); o.do_work() }
  
  event :run do
    transitions :from => :idle, :to => :running, :guard => Proc.new {|o| o.can_go? }
    transitions :from => :idle, :to => :idle
  end
  
  def stop_timer(timer)
  end
  
  def do_work
  end
  
  def can_go?
    # Returns true or false, state advances accordingly
  end
end
