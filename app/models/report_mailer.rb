class ReportMailer < ActionMailer::Base

  def daily_report(report, events)
    recipients    User.who_accepts_email
    from          "reports@snorby.org"
    subject       "Snorby Daily Report: #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}"
    sent_on       Time.now

    part "text/plain" do |p|
      p.body = render_message("daily_report.html.erb", :events => events, :report => report)
    end

    attachment "application/pdf" do |a|
      a.body = File.read("#{RAILS_ROOT}/tmp/tmp.pdf")
      a.filename = "Snorby Daily Report - #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}.pdf"
      a.transfer_encoding = "base64"
    end
  end

  def weekly_report(report, events)
    recipients    User.who_accepts_email
    from          "reports@snorby.org"
    subject       "Snorby Weekly Report: #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}"
    sent_on       Time.now

    part "text/plain" do |p|
      p.body = render_message("weekly_report.html.erb", :events => events, :report => report)
    end

    attachment "application/pdf" do |a|
      a.body = File.read("#{RAILS_ROOT}/tmp/tmp.pdf")
      a.filename = "Snorby Weekly Report - #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}.pdf"
      a.transfer_encoding = "base64"
    end
  end

  def monthly_report(report, events)
    recipients    User.who_accepts_email
    from          "reports@snorby.org"
    subject       "Snorby Monthly Report: #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}"
    sent_on       Time.now

    part "text/plain" do |p|
      p.body = render_message("monthly_report.html.erb", :events => events, :report => report)
    end

    attachment "application/pdf" do |a|
      a.body = File.read("#{RAILS_ROOT}/tmp/tmp.pdf")
      a.filename = "Snorby Monthly Report - #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}.pdf"
      a.transfer_encoding = "base64"
    end
  end


  def event_report(user, event, emails, msg)
    recipients    emails
    from          "event_report@snorby.org"
    subject       "Snorby Event Report: #{event.sig.sig_name}"
    sent_on       Time.now

    part "text/plain" do |p|
      p.body = render_message("event_report.html.erb", :event => event, :user => user, :msg => msg)
    end

    attachment "application/pdf" do |a|
      a.body = File.read("#{RAILS_ROOT}/tmp/tmp-event.pdf")
      a.filename = "Snorby Event Report - #{event.sig.sig_name}.pdf"
      a.transfer_encoding = "base64"
    end
  end
  
end
