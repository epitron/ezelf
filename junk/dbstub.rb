## dbstub! -- loads just the models without all the extra junk.

require 'rubygems'
require 'active_record'
require 'active_support'
require 'pp'

RAILS_ROOT = File.dirname( __FILE__ )
$LOAD_PATH << File.join( RAILS_ROOT, "/lib" )

module DBStub
  
  PLUGINS = [
  		#'enumerations_mixin',
  		#'acts_as_state_machine',
  		#'acts_as_paranoid',
  	]
  
  EXCLUDE_MODELS = [
  	#'u_fax_mail',
  ]
  
  
  class DBLoader
    
    def plugin_path?(path)
    	File.directory?(path) and (File.directory?(File.join(path, 'lib')) or File.file?(File.join(path, 'init.rb')))
    end
    
    def load_plugin(directory)
    	name = File.basename(directory)
    	#return false if loaded_plugins.include?(name)
    	puts "  + #{name}"	
    	
    	# Catch nonexistent and empty plugins.
    	raise LoadError, "No such plugin: #{directory}" unless plugin_path?(directory)
    	
    	lib_path  = File.join(directory, 'lib')
    	init_path = File.join(directory, 'init.rb')
    	has_lib   = File.directory?(lib_path)
    	has_init  = File.file?(init_path)
    	
    	# Add lib to load path.
    	$LOAD_PATH.unshift(lib_path) if has_lib
    	
    	# Allow plugins to reference the current configuration object
    	#config = configuration 
    	
    	# Evaluate init.rb.
    	silence_warnings { eval(IO.read(init_path), binding) } if has_init
    	
    	# Add to set of loaded plugins.
    	#loaded_plugins << name
    	true
    end
    
    def load_plugins(options)
    	puts "* Loading plugins..."
    	options[:plugins].each do |plugin_name| 
    		load_plugin(File.join(RAILS_ROOT, "vendor/plugins/#{plugin_name}"))
    	end
    end
    
    def tablename_to_constant(tablename)
    	tablename.titlecase.split(/\s/).join('')
    end	
    
    def connection
      ActiveRecord::Base.connection
    end
    
    def connect_to(options={}, autoload_models=true)
      puts "* Connecting to database..."
    	pp options
    	options[:adapter] ||= 'mysql'
    	options[:host] ||= 'localhost'
    	options[:database] ||= options["database"]
    	options[:username] ||= 'root'
    	#options[:password] ||= ''
    
    	ActiveRecord::Base::establish_connection(options)
    	
    	if autoload_models
    		puts "---------------------------------------------"
    		puts "AR Models for tables..."
    		puts "---------------------------------------------"
    		ActiveRecord::Base.connection.tables.each do |tablename| 
    			classname = tablename_to_constant(tablename)
    			eval <<-EOF
    				class #{classname} < ActiveRecord::Base
    					set_table_name "`#{tablename}`"
    				end				
    			EOF
    			puts "  + #{classname} (table='#{tablename}') #{eval("#{classname}.count")}"
    		end
    	end
    	ActiveRecord::Base.connection.tables
    end
    
    def load_models(options)
    	db_config = YAML::load(File.open("config/database.yml"))
    	#ActiveRecord::Base.establish_connection(db_config['development'])
    	connect_to(db_config['development'], false)
    	
    	puts "* Loading models..."
    	Dir.glob('app/models/*.rb').each do 
    		|f| 
    		next if options[:except].include? File.basename(f, '.rb')
    		puts "  + #{f}..."
    		begin
    		  require f 
  		  rescue SyntaxError => e
  		    puts "  |_ #{e.inspect}"
		    end
  		  
    	end
    end
    
    
  end # of DBLoader
  
    
  def self.init(options={})
    options[:plugins] = PLUGINS
    options[:except] = EXCLUDE_MODELS
    
    db = DBLoader.new
    
  	# Helpful info...
  	puts "RAILS_ROOT=#{RAILS_ROOT} | ENV=#{ENV["ENV"] || "development"}"
  	# Need the activerecord plugins...
  	db.load_plugins(options)
  	
  	# Need the ActiveRecord models, obviously!
  	db.load_models(options)
  	
  	# Put a nice blank line.
  	puts
  end
  
end

if $0 == __FILE__
  DBStub.init
end
