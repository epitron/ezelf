=begin
namespace :gems do
  desc 'Install required gems'
  task :install do
    required_gems = %w{ yard dm-core dm-validations dm-aggregates dm-is-paginated
merb-pagination sinatra haml rest-client json rack-test
mocha rspec rspec_hpricot_matchers thoughtbot-factory_girl }
 
    puts "* Checking for missing gems..."
    installed_gems = `gem list`.map { |line| $1 if line =~ /(.+) \(.+\)/ }.compact
    missing_gems = required_gems - installed_gems
 
    if missing_gems.any?
      puts " |_ Installing the following gems: #{missing_gems.join(', ')}"
      puts
      missing_gems.each { |missing_gem| system "sudo gem install #{missing_gem}" }
    else
      puts " |_ You've got all the gems!"
      puts
    end
  end
end

=end