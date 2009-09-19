#############################################################################
## Unicode!
$KCODE = 'u'
#require 'jcode'
require 'iconv'
require 'sha1'
#############################################################################



#############################################################################
## Rails Init Crap
#RAILS_GEM_VERSION = '1.2.3' unless defined? RAILS_GEM_VERSION
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION
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
## Rails Initializer
# (See Rails::Configuration for more options)

Rails::Initializer.run do |config|

  config.frameworks -= [ :action_web_service, ] #:action_mailer ]
  # config.plugins = %W( exception_notification ssl_requirement )
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  # config.log_level = :debug
  # config.action_controller.session_store = :active_record_store
  # config.action_controller.session_store = :sql_session_store
  # config.active_record.observers = :cacher, :garbage_collector
  # config.active_record.default_timezone = :utc

  config.action_controller.session = {
    :session_key => '_elfcookie',
    :secret      => %{
      Rin (臨) - Strength of mind and body
      Byō (兵) - Direction of energy
      Tō (闘) - Harmony with the universe
      Sha (者) - Healing of self and others
      Kai (皆) - Premonition of danger
      Jin (陣) - Knowing the thoughts of others
      Retsu (列) - Mastery of Time and Space
      Zai (在) - Controlling the elements of nature
      Zen (前) - Enlightenment
    }.gsub(/\s+/,'')
  }

  
  config.gem 'rio'

  
  #############################################################################
  ## MP3 Info
  require 'mp3info'
  #require 'audioinfo/album'
  config.gem 'ruby-audioinfo',   :lib=>'audioinfo', :lib=>'audioinfo/album'
  #config.gem 'ruby-mp3info',    :lib=>'mp3info'
  config.gem 'ruby-ogginfo',     :lib=>'ogginfo'
  config.gem 'MP4Info',          :lib=>'mp4info'
  config.gem 'flacinfo-rb',      :lib=>'flacinfo'
  config.gem 'wmainfo-rb',       :lib=>'wmainfo'
  config.gem 'rubyzip',          :lib=>'zip/zip'

  config.gem "thoughtbot-clearance", :lib => 'clearance', :source  => 'http://gems.github.com'

  config.gem 'thoughtbot-factory_girl',
    :lib     => 'factory_girl',
    :source  => "http://gems.github.com"
    #:version => '1.2.1'

  #require 'lib/audioinfo'
  #require 'mp3info_with_extensions'
  #############################################################################
  
  #############################################################################
  ## Music Services
  config.gem 'rbrainz'
  config.gem 'scrobbler'
  #############################################################################
  
end

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
## Clearance config
DO_NOT_REPLY = "donotreply@example.com"
#############################################################################



#############################################################################
## mONKEY pATCHES
require 'monkeypatches.rb'
#############################################################################


#############################################################################
## Misc...
require 'utils.rb'
require 'ostruct'
#############################################################################


#############################################################################
## Memory Profiler
if $DEBUG
  require 'memprof'
  MemoryProfiler.start
end
#############################################################################

