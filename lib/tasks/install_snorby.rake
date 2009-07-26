namespace :snorby do
  
  desc "Snorby DB/Cron Setup"
  task :setup => :environment do
    puts "[~] Setting Up Snorby Database."
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    puts "[~] Installing Snorby Cron Jobs."
    system('whenever --update-crontab snorby --set environment=production')
    puts '[!] Now import the snort schema: "mysql -u root -p database_name_here < db/create_mysql"'
    puts '[!] Now build the Snorby cache: "rake snorby:cache RAILS_ENV=production"'
  end
  
  desc "Snorby Reset - All Data Will Be Lost!"
  task :reset => :environment do
    puts "[~] Updating The Snorby Database."
    Rake::Task['db:migrate:reset'].invoke
    puts "[~] Installing Snorby Cron Jobs."
    system('whenever --update-crontab snorby --set environment=production')
    puts '[!] Now import the snort schema: "mysql -u root -p database_name_here < db/create_mysql"'
    puts '[!] Now build the Snorby cache: "rake snorby:cache RAILS_ENV=production"'
  end

  desc "Add/Update Snorby Cronjobs"
  task :cronjob => :environment do
    puts "Installing Snorby Cron Jobs."
    system('whenever --update-crontab snorby --set environment=production')
  end

  desc "Build Cache"
  task :cache => :environment do
    unless CalcCache.all.empty?
      puts "Cache Updated Successfully."
      CalcCache.update_cache
    else
      puts "Cache Built Successfully."
      CalcCache.build_cache
    end
  end
  
end
