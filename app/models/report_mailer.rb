class ReportMailer < ActionMailer::Base

  def daily_report(report, events, date)
    recipients  'dustin.webber@gmail.com'
    from        "reports@snorby.org"
    subject     "Snorby Daily Report: #{date.strftime('%D')}"
    body        :events => events, :report => report
    attachment "application/pdf" do |attachment|
      attachment.transfer_encoding = "base64"
      attachment.body = File.read("#{RAILS_ROOT}/tmp/tmp.pdf")
      attachment.filename = "Snorby Daily Report - #{date.strftime('%D')}.pdf"
    end
  end

  def weekly_report(report, events, date)
    recipients  'dustin.webber@gmail.com'
    from        "reports@snorby.org"
    subject     "Snorby Weekly Report: #{date.strftime('%D')} - #{Time.now.strftime('%D')}"
    body        :events => events, :report => report
    # attachment "application/pdf" do |a|
    #   a.body = report_path(report.id, :format => 'pdf')
    # end
  end

  def monthly_report(report, events, date)
    recipients  'dustin.webber@gmail.com'
    from        "reports@snorby.org"
    subject     "Snorby Monthly Report: #{date.strftime('%D')} - #{Time.now.strftime('%D')}"
    body        :events => events, :report => report
    # attachment "application/pdf" do |a|
    #   a.body = report_path(report.id, :format => 'pdf')
    # end
  end

end
