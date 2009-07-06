namespace :snorby do
  desc "Install Snorby"
  task :install => :environment do
    puts "Setting Up Snorby Database."
    Rake::Task['db:migrate'].invoke
    puts "Installing Snorby Cron Jobs."
    system('whenever --update-crontab snorby --set environment=development')
  end
  
  desc "Remove Snorby"
  task :remove => :environment do
    puts "Removing Snorby. =["
    Rake::Task['db:migrate'].invoke
    puts "Installing Snorby Cron Jobs."
    system('whenever --update-crontab snorby --set environment=development')
  end
end
