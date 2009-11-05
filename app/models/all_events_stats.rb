require 'app/model/cached_stats'

class AllEventStats < CachedStats

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
      self.last_cid = events.map { |e| e.cid }.max
    end
  end

end
