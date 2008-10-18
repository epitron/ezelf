# Load the global SETTINGS variable.

require 'pp'


## Locate the file
SETTINGS_FILE = "#{RAILS_ROOT}/config/settings.yml"
raise "Error: Cannot find #{SETTINGS_FILE}" unless File.exist? SETTINGS_FILE


## Load the file
puts "* Loading #{SETTINGS_FILE}"

## environment-specific settings.yml
#yaml = YAML::load_file(SETTINGS_FILE).with_indifferent_access
#SETTINGS = yaml[RAILS_ENV] || {}

## regular settings.yml
SETTINGS = YAML::load_file(SETTINGS_FILE).with_indifferent_access


## Display settings
puts "Settings:"
puts "----------------------"
pp SETTINGS
puts
