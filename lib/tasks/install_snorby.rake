require 'yaml'
@dbconfig = YAML::load(File.open(RAILS_ROOT + '/config/database.yml'))

namespace :snorby do

  desc "Snorby DB/Cron Setup"
  task :setup => :environment do
    puts "[~] Setting Up Snorby Database."
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    puts '[~] Importing snort DB schema...'
    system("mysql -u #{@dbconfig['production']['username']} --password=#{@dbconfig['production']['password']} #{@dbconfig['production']['database']} < #{RAILS_ROOT}/db/create_mysql")
    Rake::Task['snorby:cache'].invoke
    Rake::Task['snorby:cronjob'].invoke
  end

  desc "Snorby Reset - All Data Will Be Lost!"
  task :reset => :environment do
    puts "[~] Updating The Snorby Database."
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    puts '[~] Importing snort DB schema...'
    system("mysql -u #{@dbconfig['production']['username']} --password=#{@dbconfig['production']['password']} #{@dbconfig['production']['database']} < #{RAILS_ROOT}/db/create_mysql")
    Rake::Task['snorby:cache'].invoke
    Rake::Task['snorby:cronjob'].invoke
  end
  
  desc "Snorby Update"
  task :update => :environment do
    
    ### VERSION SPECIFIC MIGRATIONS
    puts '[~] Updating Snorby...'
    puts '[~] Please Wait...'
    system('rake db:migrate:down RAILS_ENV=production VERSION=20090628215615')
    system('rake db:migrate:up RAILS_ENV=production VERSION=20090628215615')
    ### END
    Rake::Task['db:migrate'].invoke
    Rake::Task['snorby:cache'].invoke
    Rake::Task['snorby:cronjob'].invoke
  end

  desc "Add/Update Snorby Cronjobs"
  task :cronjob => :environment do
    puts "[~] Installing/Updating Snorby Cron Jobs."
    system('whenever --update-crontab snorby --set environment=production')
  end

  desc "Build Cache"
  task :cache => :environment do
    unless CalcCache.all.blank?
      puts "[~] Cache Updated Successfully."
      CalcCache.update_cache
    else
      puts "[~] Cache Built Successfully."
      CalcCache.build_cache
    end
  end

end
