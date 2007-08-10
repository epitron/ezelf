modules_to_load = [
  'irb/completion', 
  'pp',
  'rubygems',
]

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:USE_READLINE] = true

IRB.conf[:LOAD_MODULES] ||= []

modules_to_load.each do |m|
  unless IRB.conf[:LOAD_MODULES].include?(m)
    IRB.conf[:LOAD_MODULES] << m
  end
end


%w{dbstub wirble}.each {|mod| require mod}

DBStub.init
Wirble.init
#Wirble.colorize
