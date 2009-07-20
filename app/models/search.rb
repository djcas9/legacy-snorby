class Search < ActiveRecord::Base

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
    Event.find(:all, :include => [:sensor, :comments, :iphdr, {:sig => :sig_class }], :order => 'timestamp DESC', :conditions => conditions)
  end

  def keyword_conditions
    ["signature.sig_name LIKE ?", "%#{keywords}%"] unless keywords.blank?
  end

  def sensor_conditions
    ["sensor.sid = ?", sid] unless sid.blank?
  end

  def sig_class_conditions
    ["signature.sig_class_id = ?", sid_class_id] unless sid_class_id.blank?
  end

  def source_ip_conditions
    ["inet_ntoa(iphdr.ip_src) = ?", ip_src] unless ip_src.blank?
  end

  def destination_ip_conditions
    ["inet_ntoa(iphdr.ip_dst) = ?", ip_dst] unless ip_dst.blank?
  end

  def source_port_conditions
    ["udphdr.udp_sport = ? OR tcphdr.tcp_sport = ?", sport, sport] unless sport.blank?
  end

  def destination_port_conditions
    ["udphdr.udp_dport = ? OR tcphdr.tcp_dport = ?", dport, dport] unless dport.blank?
  end
  
  def sig_priority_conditions
    ["signature.sig_priority = ?", sig_priority] unless sig_priority.blank?
  end

  def start_time_conditions
    ["timestamp >= ?", start_time] unless start_time.blank?
  end
  
  def end_time_conditions
    ["timestamp <= ?", end_time] unless end_time.blank?
  end

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end

end
