require 'app/models/cached_stats'

class UniqueEventsStats < CachedStats

  def calculate!
    super do
      events = Event.all(
        :group => 'signature',
        :conditions => ['cid > ?', self.last_cid]
      )

      self.statistic = events.size
      self.last_cid = max_cid(events)
    end
  end

end
