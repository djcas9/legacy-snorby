class CalcCache < ActiveRecord::Base
  
  def self.grab_cache(options = {})
  end
  
  def self.add_to_cache(options = {})
  end
  
  def self.rebuild_cache(options = {})
    @events = Event.all(:include => [:sensor, :iphdr, {:sig => :sig_class }])
    @events.each do |event|
     cache_event = CalcCache.create(:name => event.sig.sig_name, 
     :severity => event.sig.sig_priority, 
     :date => event.timestamp, 
     :hour => event.timestamp.hour, 
     :count => "?")
     cache_event.save!
    end
  end
  
  def self.destroy_cache(options = {})
  end
  
end


# DB
# t.string   "name"
# t.integer  "severity"
# t.string   "date"
# t.integer  "hour"
# t.integer  "count"
# t.datetime "created_at"
# t.datetime "updated_at"