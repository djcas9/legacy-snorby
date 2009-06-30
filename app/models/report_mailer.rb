class ReportMailer < ActionMailer::Base
  
  def daily_report(user, events, date)
    recipients  'dustin.webber@gmail.com'
    from        "reports@snorby.org"
    subject     "Snorby Report for #{date}"
    body        :events => events
  end
  
  def weekly_report(user, events, date)
    recipients  'dustin.webber@gmail.com'
    from        "reports@snorby.org"
    subject     "Snorby Report for #{date}"
    body        :events => events
  end
  
  def monthly_report(user, events, date)
    recipients  'dustin.webber@gmail.com'
    from        "reports@snorby.org"
    subject     "Snorby Report for #{date}"
    body        :events => events
  end

end
