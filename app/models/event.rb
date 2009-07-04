class Event < ActiveRecord::Base
  set_table_name 'event'
  set_primary_keys :sid, :cid
  belongs_to :sensor, :class_name => "Sensor", :foreign_key => 'sid'
  belongs_to :iphdr, :class_name => "Iphdr", :foreign_key => [:sid, :cid], :dependent => :destroy
  belongs_to :tcphdr, :class_name => "Tcphdr", :foreign_key => [:sid, :cid], :dependent => :destroy
  belongs_to :icmphdr, :class_name => "Icmphdr", :foreign_key => [:sid, :cid], :dependent => :destroy
  belongs_to :udphdr, :class_name => "Udphdr", :foreign_key => [:sid, :cid], :dependent => :destroy
  belongs_to :data_info, :class_name => 'Data_Info', :foreign_key => [:sid, :cid], :dependent => :destroy
  belongs_to :opt, :class_name => 'Opt', :foreign_key => [:sid, :cid], :dependent => :destroy
  
  belongs_to :sig, :class_name => "Signature", :foreign_key => 'signature'
  belongs_to :sig_reference, :class_name => "SigReference", :foreign_key => 'signature', :dependent => :destroy
  
  def self.run_daily_report
    @events = self.find(:all, :conditions => ['timestamp >= ?', Chronic.parse('one day ago')])
    report = Report.new(:title => "Daily Report For #{Chronic.parse('one day ago')}", :rtype => 'daily', :from_time => "#{Chronic.parse('one day ago')}", :to_time => "#{Time.now}")
    if report.save!
      Pdf_for_email.make_pdf(report, @events)
      ReportMailer.deliver_daily_report(report, @events, Chronic.parse('one day ago'))
    end
  end
  
  def self.run_weekly_report
    @events = self.find(:all, :conditions => ['timestamp >= ?', Chronic.parse('one week ago')])
    report = Report.new(:title => "Weekly Report For #{Chronic.parse('one week ago')}", :rtype => 'weekly', :from_time => "#{Chronic.parse('one week ago')}", :to_time => "#{Time.now}")
    if report.save!
      Pdf_for_email.make_pdf(report, @events)
      ReportMailer.deliver_weekly_report(report, @events, Chronic.parse('one week ago'))
    end
  end
  
  def self.run_monthly_report
    @events = self.find(:all, :conditions => ['timestamp >= ?', Chronic.parse('one month ago')])
    report = Report.new(:title => "Monthly Report For #{Chronic.parse('one month ago')}", :rtype => 'monthly', :from_time => "#{Chronic.parse('one month ago')}", :to_time => "#{Time.now}")
    if report.save!
      Pdf_for_email.make_pdf(report, @events)
      ReportMailer.deliver_monthly_report(report, @events, Chronic.parse('one month ago'))
    end
  end
  
end
