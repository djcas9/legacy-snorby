class ReportMailer < ActionMailer::Base

  def daily_report(report, emails, events, date)
    recipients    emails
    from          "reports@snorby.org"
    subject       "Snorby Daily Report: #{date.strftime('%D')}"
    content_type  "multipart/alternative"
    body          :events => events, :report => report
    sent_on       Time.now
    
    attachment "application/pdf" do |a|
      a.body = File.read("#{RAILS_ROOT}/tmp/tmp.pdf")
      a.filename = "Snorby Daily Report - #{date.strftime('%D')}.pdf"
    end
  end

  def weekly_report(report, emails, events, date)
    recipients    emails
    from          "reports@snorby.org"
    subject       "Snorby Weekly Report: #{date.strftime('%D')}"
    content_type  "multipart/alternative"
    body          :events => events, :report => report
    sent_on       Time.now
    
    attachment "application/pdf" do |a|
      a.body = File.read("#{RAILS_ROOT}/tmp/tmp.pdf")
      a.filename = "Snorby Daily Report - #{date.strftime('%D')}.pdf"
    end
  end

  def monthly_report(report, emails, events, date)
    recipients    emails
    from          "reports@snorby.org"
    subject       "Snorby Monthly Report: #{date.strftime('%D')}"
    content_type  "multipart/alternative"
    body          :events => events, :report => report
    sent_on       Time.now
    
    attachment "application/pdf" do |a|
      a.body = File.read("#{RAILS_ROOT}/tmp/tmp.pdf")
      a.filename = "Snorby Daily Report - #{date.strftime('%D')}.pdf"
    end
  end

end
