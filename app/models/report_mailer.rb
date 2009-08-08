class ReportMailer < ActionMailer::Base

  def daily_report(report, events)
    recipients    User.who_accepts_email
    from          "reports@snorby.org"
    subject       "#{Setting.device_name} - Daily Report: #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}"
    sent_on       Time.now

    part "text/plain" do |p|
      p.body = render_message("daily_report.html.erb", :events => events, :report => report)
    end

    attachment "application/pdf" do |a|
      a.body = File.read("#{RAILS_ROOT}/tmp/tmp.pdf")
      a.filename = "#{Setting.device_name} - Daily Report - #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}.pdf"
      a.transfer_encoding = "base64"
    end
  end

  def weekly_report(report, events)
    recipients    User.who_accepts_email
    from          "reports@snorby.org"
    subject       "#{Setting.device_name} - Weekly Report: #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}"
    sent_on       Time.now

    part "text/plain" do |p|
      p.body = render_message("weekly_report.html.erb", :events => events, :report => report)
    end

    attachment "application/pdf" do |a|
      a.body = File.read("#{RAILS_ROOT}/tmp/tmp.pdf")
      a.filename = "#{Setting.device_name} - Weekly Report - #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}.pdf"
      a.transfer_encoding = "base64"
    end
  end

  def monthly_report(report, events)
    recipients    User.who_accepts_email
    from          "reports@snorby.org"
    subject       "#{Setting.device_name} - Monthly Report: #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}"
    sent_on       Time.now

    part "text/plain" do |p|
      p.body = render_message("monthly_report.html.erb", :events => events, :report => report)
    end

    attachment "application/pdf" do |a|
      a.body = File.read("#{RAILS_ROOT}/tmp/tmp.pdf")
      a.filename = "#{Setting.device_name} - Monthly Report - #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}.pdf"
      a.transfer_encoding = "base64"
    end
  end


  def event_report(user, event, emails, msg)
    recipients    emails
    from          "reports@snorby.org"
    subject       "#{Setting.device_name} - Event Report: #{event.sig.sig_name}"
    sent_on       Time.now

    part "text/plain" do |p|
      p.body = render_message("event_report.html.erb", :event => event, :user => user, :msg => msg)
    end

    attachment "application/pdf" do |a|
      a.body = File.read("#{RAILS_ROOT}/tmp/tmp-event.pdf")
      a.filename = "#{Setting.device_name} - Event Report - #{event.sig.sig_name}.pdf"
      a.transfer_encoding = "base64"
    end
  end

  def search_report(user, search, emails, msg)
    recipients    emails
    from          "reports@snorby.org"
    subject       "#{Setting.device_name} - Security Report"
    sent_on       Time.now

    part "text/plain" do |p|
      p.body = render_message("search_report.html.erb", :search => search, :user => user, :msg => msg)
    end

    attachment "application/pdf" do |a|
      a.body = File.read("#{RAILS_ROOT}/tmp/tmp-search.pdf")
      a.filename = "#{Setting.device_name} Security Report - #{search.id}.pdf"
      a.transfer_encoding = "base64"
    end
  end

  def report_report(user, report, emails, msg)
    recipients    emails
    from          "reports@snorby.org"
    subject       "#{Setting.device_name} - #{report.rtype.capitalize} Report: #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}"
    sent_on       Time.now

    part "text/plain" do |p|
      p.body = render_message("report_report.html.erb", :report => report, :msg => msg)
    end

    attachment "application/pdf" do |a|
      a.body = File.read("#{RAILS_ROOT}/tmp/tmp.pdf")
      a.filename = "#{Setting.device_name} - #{report.rtype.capitalize} Report - #{DateTime.parse(report.from_time).strftime('%D')}-#{DateTime.parse(report.to_time).strftime('%D')}.pdf"
      a.transfer_encoding = "base64"
    end
  end

end
