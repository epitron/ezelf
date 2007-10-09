class ActiveRecordTestConnector
  cattr_accessor :able_to_connect
  cattr_accessor :connected

  # Set our defaults
  self.connected = false
  self.able_to_connect = true

  def self.setup
    unless connected || !able_to_connect
      setup_connection
      load_schema
      require_fixture_models
      self.connected = true
    end
  rescue Exception => e  # errors from ActiveRecord setup
    if e.to_s =~ /unknown database/i
      puts "\nPlease create an `ambition_development' database to play!"
    else
      $stderr.puts "\nSkipping ActiveRecord assertion tests: #{e}"
    end
    self.able_to_connect = false
  end

  private

  def self.setup_connection
    if Object.const_defined?(:ActiveRecord)
      config_file = File.dirname(__FILE__) + '/../database.yml'
      ActiveRecord::Base.logger = Logger.new STDOUT
      
      case adapter = ENV['ADAPTER'] || 'mysql'
      when 'sqlite3'
        options = { :database => ':memory:', :adapter => 'sqlite3', :timeout => 500 }
        ActiveRecord::Base.configurations = { 'sqlite3_ar_integration' => options }
      else
        options = YAML.load_file(config_file)[adapter]
      end

      puts "Using #{adapter}"

      ActiveRecord::Base.establish_connection(options)
      ActiveRecord::Base.connection

      unless Object.const_defined?(:QUOTED_TYPE)
        Object.send :const_set, :QUOTED_TYPE, ActiveRecord::Base.connection.quote_column_name('type')
      end
    else
      raise "Can't setup connection since ActiveRecord isn't loaded."
    end
  end

    # Load actionpack sqlite tables
  def self.load_schema
    ActiveRecord::Base.silence do
      load File.dirname(__FILE__) + "/schema.rb"
    end
  end

  def self.require_fixture_models
    models = Dir.glob(File.dirname(__FILE__) + "/../fixtures/*.rb")
    models = (models.grep(/user.rb/) + models).uniq
    models.each {|f| require f}
  end
end
