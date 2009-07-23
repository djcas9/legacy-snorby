class CalcCache < ActiveRecord::Base
  serialize :sensor_cache
  serialize :category_cache
  
  def self.update_cache
    get_cache = CalcCache.find(1)
    data = CalcCache.calculate_data
    cache = get_cache.update_attributes(:last_cache => Time.now,
    :high_severity => data[:high],
    :medium_severity => data[:medium],
    :low_severity => data[:low],
    :total_event_count => data[:all],
    :unique_event_count => data[:uniq_events],
    :unique_address_count => data[:uniq_adds],
    :sensor_cache => data[:sensor_cache],
    :category_cache => data[:category_cache])
  end
  
  def self.build_cache
    data = CalcCache.calculate_data
    cache = CalcCache.new(:id => 1,
    :last_cache => Time.now,
    :high_severity => data[:high],
    :medium_severity => data[:medium],
    :low_severity => data[:low],
    :total_event_count => data[:all],
    :unique_event_count => data[:uniq_events],
    :unique_address_count => data[:uniq_adds],
    :sensor_cache => data[:sensor_cache],
    :category_cache => data[:category_cache])
    cache.save!
  end
  
  def self.calculate_data
    data = {}
    data[:high] = Event.event_count_for(1)
    data[:medium] = Event.event_count_for(2)
    data[:low] = Event.event_count_for(3)
    data[:all] = Event.all(:include => :sig).size
    data[:uniq_events] = Event.all(:group => 'signature').size
    data[:uniq_adds] = Iphdr.find(:all, :group => 'ip_src').uniq.size + Iphdr.find(:all, :group => 'ip_dst').uniq.size
    data[:sensor_cache] = CalcCache.build_sensor_hash
    data[:category_cache] = CalcCache.build_category_hash
    return data
  end
  
  def self.build_category_hash
    category_hash = Hash.new
    @categories = SigClass.get_category_information
    @categories.each do |name, id|
      category_hash["#{id}"] = { :id => id,
        :name => name, 
        :event_total => SigClass.events_for_this_category(id) }
    end
    return category_hash
  end
  
  def self.build_sensor_hash
    sensor_hash = Hash.new
    @sensors = Sensor.all :include => :events, :order => 'sid ASC'
    @sensors.each do |sensor|
      sensor_hash["#{sensor.id}"] = { :sensor_id => sensor.id,
        :hostname => sensor.hostname, 
        :interface => sensor.interface, 
        :encoding => sensor.encoding_type, 
        :last_cid => sensor.last_cid, 
        :event_total => sensor.events.size }
    end
    return sensor_hash
  end
  
  def self.destroy
    get_cache = CalcCache.find(2)
    data = CalcCache.calculate_data
    cache = get_cache.update_attributes(
    :id => 1
    :last_cache => Time.now,
    :high_severity => 0,
    :medium_severity => 0,
    :low_severity => 0,
    :total_event_count => 0,
    :unique_event_count => 0,
    :unique_address_count => 0,
    :sensor_cache => 0,
    :category_cache => 0)
  end
  
end