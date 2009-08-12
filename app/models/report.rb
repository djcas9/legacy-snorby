class Report < ActiveRecord::Base

  def events
    @all_events ||= find_events
  end
  
  def page_events(page)
    find_page_events(page)
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
    Event.find(:all, :include => [:sensor, :comments, :iphdr, {:sig => :sig_class }], :conditions => ['timestamp >= ? AND timestamp <= ?', DateTime.parse(from_time), DateTime.parse(to_time)], :order => 'timestamp DESC')
  end
  
  def find_page_events(page)
    Event.paginate(:per_page => Setting.events_per_page, 
    :page => page,
    :joins => [:sensor, :iphdr, :tcphdr, :udphdr, :sig],
    :include => [:sensor, :comments, :iphdr, :tcphdr, :udphdr, :sig],
    :conditions => ['timestamp >= ? AND timestamp <= ?', DateTime.parse(from_time), DateTime.parse(to_time)], 
    :order => 'timestamp DESC')
  end
  
end
