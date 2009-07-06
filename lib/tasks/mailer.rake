desc "Send Event Report"
task :event_mailing => :environment do
  ReportMailer.deliver_event_report(ENV["USER"], ENV["EVENT"], ENV["EMAILS"], ENV["MSG"])
end