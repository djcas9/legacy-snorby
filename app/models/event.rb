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
  
  belongs_to :sig, :class_name => "Signature", :foreign_key => 'signature', :dependent => :destroy
  belongs_to :sig_reference, :class_name => "SigReference", :foreign_key => 'signature', :dependent => :destroy
  
  
  
  def run_daily_report
    self.find(:all, :conditions => ['timestamp >= ?', Chronic.parse('one day ago')])
  end
  
  def run_weekly_report
    self.find(:all, :conditions => ['timestamp >= ?', Chronic.parse('one week ago')])
  end
  
  def run_monthly_report
    self.find(:all, :conditions => ['timestamp >= ?', Chronic.parse('one month ago')])
  end
  
end
