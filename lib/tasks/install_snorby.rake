require 'yaml'
@dbconfig = YAML::load(File.open(RAILS_ROOT + '/config/database.yml'))

namespace :snorby do

  desc "Snorby Setup/Install"
  task :setup => :environment do
    puts "[~] Setting Up Snorby Database."
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    puts '[~] Importing snort DB schema...'
    system("mysql -u #{@dbconfig['production']['username']} --password=#{@dbconfig['production']['password']} #{@dbconfig['production']['database']} < #{RAILS_ROOT}/db/create_mysql")
    Rake::Task['snorby:cache'].invoke
    Rake::Task['snorby:cronjob'].invoke
    
    Rake::Task['db:seed'].invoke
    
  end

  desc "Snorby Reset - All Data Will Be Lost!"
  task :reset => :environment do
    
    snorby_header_info("Snorby Reset - All Data Will Be Lost!")
    
    puts "[~] Updating The Snorby Database."
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    puts '[~] Importing snort DB schema...'
    system("mysql -u #{@dbconfig['production']['username']} --password=#{@dbconfig['production']['password']} #{@dbconfig['production']['database']} < #{RAILS_ROOT}/db/create_mysql")
    Rake::Task['snorby:cache'].invoke
    Rake::Task['snorby:cronjob'].invoke
    
    Rake::Task['db:seed'].invoke
    
    snorby_footer_info("Snorby Update") do
    puts <<-EOF
    The Default login credintials are:
    User: snorby@snorby.org
    Password: admin
    EOF
    end
    
  end
  
  desc "Snorby Update"
  task :update => :environment do
    
    snorby_header_info("Snorby Update to #{SNORBY_VERSION}")
    
    ### VERSION SPECIFIC MIGRATIONS
    puts '[~] Updating Snorby...'
    puts '[~] Please Wait...'
    
    # Settings
    system('rake db:migrate:down RAILS_ENV=production VERSION=20090626044640') # Settings
    system('rake db:migrate:up RAILS_ENV=production VERSION=20090626044640') # Settings
    # Users
    system('rake db:migrate:down RAILS_ENV=production VERSION=20090628215615') # User
    system('rake db:migrate:up RAILS_ENV=production VERSION=20090628215615') # User
    
    ### END
    Rake::Task['db:migrate'].invoke
    Rake::Task['tmp:clear'].invoke
    Rake::Task['tmp:create'].invoke
    Rake::Task['snorby:cache'].invoke
    Rake::Task['snorby:cronjob'].invoke
    
    Rake::Task['db:seed'].invoke
    
    snorby_footer_info("Snorby Update") do
    puts <<-EOF
    The Default login credintials are:
    User: snorby@snorby.org
    Password: admin
    EOF
    end
    
  end

  desc "Add/Update Snorby Cronjobs"
  task :cronjob => :environment do
    snorby_header_info("Snorby Cronjob Update")
    puts "[~] Installing/Updating Snorby Cron Jobs."
    system('whenever --update-crontab snorby --set environment=production')
    snorby_footer_info("Snorby Update") do
    puts <<-EOF
    If The cronjobs are not being installed or listed with 'crontab -l'
    Please install: sudo gem install javan-whenever 
    EOF
    end
  end

  desc "Build Cache"
  task :cache => :environment do
    unless CalcCache.all.blank?
      snorby_header_info("Snorby Cache Update")
      puts "[~] Cache Updated Successfully."
      CalcCache.update_cache
    else
      snorby_header_info("Building Snorby Cache")
      puts "[~] Cache Built Successfully."
      CalcCache.build_cache
    end
    snorby_footer_info("Snorby Cache") do
    puts <<-EOF
    Snorby will cache every hour and clicking the refresh icon on the dashboard will force cache updates.
    Some cache updates may take awhile before data changes can be observed.
    EOF
    end
  end
  
  
  def snorby_header_info(msg)
    puts "\n--------------------"
    puts "#{msg}"
    puts "--------------------\n\n"
  end
  
  def snorby_footer_info(rake_type, *block)
    puts "\n--------------------"
    puts "#{rake_type} Complete!"
    puts "\n"
    puts "#{yield}\n"
  end

end
