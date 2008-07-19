###############################################################################
## "settings.yml" loader

require 'yaml'
require 'ostruct'
require 'pp'

def load_settings
	yml = YAML::load_file File.join(File.dirname(__FILE__), 'settings.yml')
	OpenStruct.new( yml )
end

SETTINGS = load_settings

puts "SETTINGS:"
pp SETTINGS.instance_variable_get('@table')

