class PreCommit::Rspec < PreCommit
  def pre_commit
    check_for_gem_dependencies
    fix_cr_lf
    touch_revision_storing_files
    pre_commit_core
    pre_commit_rails
    ok_to_commit
  end
  
  def check_for_gem_dependencies
    gem 'rake'
    gem 'rcov'
    gem 'webgen', '>= 0.4.2'
    gem 'RedCloth'
    gem 'syntax'
    gem 'diff-lcs'
    gem 'heckle' unless PLATFORM == "i386-mswin32"
    gem 'hpricot'
  end

  def fix_cr_lf
    files = FileList['**/*.rb'].
            exclude('example_rails_app/vendor/**').
            exclude('rspec/translated_specs/**')
    $\="\n"
    files.each do |f|
      raw_content = File.read(f)
      fixed_content = ""
      raw_content.each_line do |line|
        fixed_content << line
      end
      unless raw_content == fixed_content
        File.open(f, "w") do |io|
          io.print fixed_content
        end
      end
    end
  end
  
  def touch_revision_storing_files
    # See http://svnbook.red-bean.com/en/1.0/ch07s02.html - the section on svn:keywords
    files = [
      'rspec/lib/spec/version.rb',
      'rspec_on_rails/lib/spec/rails/version.rb'
    ]
    new_token = rand
    files.each do |path|
      abs_path = File.join(root_dir, path)
      content = File.open(abs_path).read
      touched_content = content.gsub(/# RANDOM_TOKEN: (.*)\n/n, "# RANDOM_TOKEN: #{new_token}\n")
      File.open(abs_path, 'w') do |io|
        io.write touched_content
      end
    end
  end
  
  def pre_commit_core
    Dir.chdir 'rspec' do
      rake = (PLATFORM == "i386-mswin32") ? "rake.bat" : "rake"
      system("#{rake} pre_commit --verbose --trace")
      raise "RSpec Core pre_commit failed" if error_code?
    end    
  end

  def install_dependencies
    Dir.chdir 'example_rails_app' do
      rake_sh("-f Multirails.rake install_dependencies")
    end
  end

  def update_dependencies
    Dir.chdir 'example_rails_app' do
      rake_sh("-f Multirails.rake update_dependencies --trace")
    end
  end

  def pre_commit_rails
    Dir.chdir 'example_rails_app' do
      rake = (PLATFORM == "i386-mswin32") ? "rake.cmd" : "rake"
      cmd = "#{rake} -f Multirails.rake pre_commit --trace"
      system(cmd)
      if error_code?
        message = <<-EOF
        ############################################################
        RSpec on Rails Plugin pre_commit failed. For more info:

          cd example_rails_app
          #{cmd}

        ############################################################
        EOF
        raise message.gsub(/^        /, '')
      end
    end
  end
  
  def ok_to_commit
    puts "OK TO COMMIT"
  end
end