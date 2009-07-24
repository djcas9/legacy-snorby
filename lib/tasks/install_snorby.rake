namespace :snorby do
  desc "Snorby DB/Cron Setup"
  task :setup => :environment do
    puts "Setting Up Snorby Database."
    Rake::Task['db:migrate'].invoke
    puts "Installing Snorby Cron Jobs."
    system('whenever --update-crontab snorby --set environment=production')
  end

  desc "Remove Snorby"
  task :remove => :environment do
    puts "Removing Snorby. =["
    Rake::Task['db:migrate'].invoke
    puts "Installing Snorby Cron Jobs."
    system('whenever --update-crontab snorby --set environment=production')
  end

  desc "Add/Update Snorby Cronjobs"
  task :cronjob => :environment do
    puts "Installing Snorby Cron Jobs."
    system('whenever --update-crontab snorby --set environment=production')
  end

  desc "Build Cache"
  task :build_cache => :environment do
    if CalcCache.build_cache
      puts "Cache Built Successfully."
    else
      CalcCache.update_cache
    end
  end
end
