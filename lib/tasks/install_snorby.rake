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
