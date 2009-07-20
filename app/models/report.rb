class Report < ActiveRecord::Base
  has_many :events, :select => 'DISTINCT signature.sig_name'
  
  
  def events
    @events ||= find_events
  end

  def count_events
    counts = Hash.new(0)
    self.events.each do |ev|
      counts["#{ev.sig.sig_name}|#{ev.iphdr.ip_src}|#{ev.iphdr.ip_dst}|#{ev.sig.sig_priority}|#{ev.sensor.sid}"] += 1
    end
    counts
  end
  
  private
  
  def find_events
    Event.find(:all, :include => [:sensor, :comments, :iphdr, {:sig => :sig_class }], :conditions => ['timestamp >= ? AND timestamp <= ?', DateTime.parse(from_time), DateTime.parse(to_time)], :order => 'timestamp DESC', :group => 'signature')
    #Event.paginate(:page => page, :per_page => 20, :conditions => ['timestamp >= ? AND timestamp <= ?', DateTime.parse(from_time), DateTime.parse(to_time)], :include => [:sensor, :sig, :iphdr, :icmphdr, :tcphdr, :udphdr], :order => 'timestamp DESC')
  end
  
end
