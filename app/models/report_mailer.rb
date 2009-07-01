class ReportMailer < ActionMailer::Base
  
  def daily_report(events, date)
    recipients  'dustin.webber@gmail.com'
    from        "reports@snorby.org"
    subject     "Snorby Daily Report: #{date.strftime('%D')}"
    body        :events => events
  end
  
  def weekly_report(events, date)
    recipients  'dustin.webber@gmail.com'
    from        "reports@snorby.org"
    subject     "Snorby Weekly Report: #{date.strftime('%D')} - #{Time.now.strftime('%D')}"
    body        :events => events
  end
  
  def monthly_report(events, date)
    recipients  'dustin.webber@gmail.com'
    from        "reports@snorby.org"
    subject     "Snorby Monthly Report: #{date.strftime('%D')} - #{Time.now.strftime('%D')}"
    body        :events => events
  end

end
