#require 'dbstub'
#require 'rubygems'
#require 'active_record'
require 'active_record/fixtures'


#ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)  
#init_dbstub

def import_fixture(name, fixture_dir='spec/fixtures')
	puts "* Importing fixture: #{name}"
	Dir.glob(File.join(RAILS_ROOT, fixture_dir, "#{name}.{yml,csv}")).each do |fixture_file|
		puts "   - checking #{fixture_file}"
		if name == File.basename(fixture_file, '.*')
			puts "   + Importing #{fixture_file}..."
			Fixtures.create_fixtures(fixture_dir, File.basename(fixture_file, '.*'))
		else
			puts "! Error: can't find %s" % fixture_file
		end
	end
end

#def import_fixtures(fixtures, fixture_dir='test/fixtures')
#	puts "...Importing fixtures: #{fixtures.inspect}"
#	fixtures.each do |name|
#		import_fixture(name, fixture_dir)
#	end
#end

