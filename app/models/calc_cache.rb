class CalcCache < ActiveRecord::Base
  
  def self.update_cache
    @cache = CalcCache.find(1)
    data = CalcCache.calculate_data
    cache = @cache.update_attributes(:last_cache => Time.now,
    :high_severity => 0,
    :medium_severity => data[:medium],
    :low_severity => data[:low],
    :total_event_count => data[:all],
    :unique_event_count => data[:uniq_events],
    :unique_address_count => data[:uniq_adds],
    :sensor_cache => 0,
    :category_cache => 0)
  end
  
  def self.build_cache
    data = CalcCache.calculate_data
    cache = CalcCache.create_or_update(:id => 1,
    :last_cache => Time.now,
    :high_severity => data[:high],
    :medium_severity => data[:medium],
    :low_severity => data[:low],
    :total_event_count => data[:all],
    :unique_event_count => data[:uniq_events],
    :unique_address_count => data[:uniq_adds],
    :sensor_cache => 0,
    :category_cache => 0)
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
    return data
  end
  
  def self.destroy_cache
  end
  
end