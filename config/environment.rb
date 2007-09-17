#############################################################################
## Unicode!
$KCODE = 'u'
require 'jcode'
require 'iconv'
require 'sha1'
#############################################################################



#############################################################################
## Rails Init Crap
RAILS_GEM_VERSION = '1.2.3' unless defined? RAILS_GEM_VERSION
# ENV['RAILS_ENV'] ||= 'production'
require File.join(File.dirname(__FILE__), 'boot')
#############################################################################


#############################################################################
## ELF Settings
#require File.join(File.dirname(__FILE__), 'settings')
#############################################################################


#############################################################################
## ELF Exceptions
require File.join(File.dirname(__FILE__), 'exceptions')
#############################################################################


#############################################################################
## Rails Config Crap
Rails::Initializer.run do |config|

  config.frameworks -= [ :action_web_service, :action_mailer ]
  # config.plugins = %W( exception_notification ssl_requirement )
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  # config.log_level = :debug
  # config.action_controller.session_store = :active_record_store
  # config.action_controller.session_store = :sql_session_store
  # config.active_record.observers = :cacher, :garbage_collector
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

#############################################################################


#############################################################################
## Fast SQL Session Store

case ActiveRecord::Base.connection.adapter_name
  when "SQLite"
  when "MySQL"
    ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.update(:database_manager => SqlSessionStore)
    SqlSessionStore.session_class = MysqlSession
end

#############################################################################


#############################################################################
## mONKEY pATCHES
require 'monkeypatches.rb'
#############################################################################


#############################################################################
## MP3 Info
require 'mp3info_with_extensions'
#############################################################################

#require 'ruby-debug'; debugger


#############################################################################
## Memory Profiler
require 'memprof'
MemoryProfiler.start
#############################################################################


#############################################################################
## Music Services
require 'scrobbler'
require 'rbrainz'
#############################################################################
