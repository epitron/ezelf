require 'import_fixtures'

namespace :db do

  desc "Reimport..."
  task :reimport => [:environment] do
    puts "+ Removing dev database..."
    dbfile = "#{RAILS_ROOT}/db/dev.db"
    rm dbfile if File.exists? dbfile
    
    puts "+ Removing schema.rb..."
    schema = "#{RAILS_ROOT}/db/schema.rb"
    rm schema if File.exists? schema
    
    puts "+ Migrating..."
    Rake::Task["db:migrate"].invoke
    #Rake::Task["db:import_fixtures"].invoke
    
    puts "+ Annotating..."
    Rake::Task["annotate_models"].invoke
  end
  
  desc "Import fixtures..."
  task :import_fixtures => [:environment] do
    #fixtures = %w(products product_types images users colors turnarounds)
    fixtures = Dir["#{RAILS_ROOT}/spec/fixtures/*.yml"]

    fixtures.each do |fixture|
      import_fixture(fixture)
    end
    
    #Rake::Task[:secondary].invoke
  end
  
end
