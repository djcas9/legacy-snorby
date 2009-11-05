# require 'app/model/cached_stats.rb'

class AllEventsStats < CachedStats

  #
  # Calculates the statistics for events of all severities that have been
  # previously seen.
  #
  def calculate!
    super do
      events = Event.all(
        :include => :sig,
        :conditions => ['cid > ?', self.last_cid]
      )

      self.statistic = events.size
      self.last_cid = max_cid(events)
    end
  end

end
