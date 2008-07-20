require "rails_generator"

class Rails::Generator::Commands::Base
  protected
  def current_migration_number
    Dir.glob("#{RAILS_ROOT}/#{@migration_directory}/[0-9]*_*.rb").inject(0) do |max, file_path|
      n = File.basename(file_path).split('_', 2).first.to_i
      if n > max then n else max end
    end
  end
 
  def next_migration_number
    current_migration_number + 1
  end
 
  def next_migration_string(padding = 3)
    "%.#{padding}d" % next_migration_number
  end
end
