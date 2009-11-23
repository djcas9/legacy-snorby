class AllEventsStats < CachedStats

  #
  # Calculates the statistics for events of all severities that have been
  # previously seen.
  #
  def calculate!
    super do
      events = Event.all(
        :include => :sig,
        :conditions => [
          'timestamp >= :starting_time AND timestamp < :stopping_time',
          {
            :starting_time => self.starting_time,
            :stopping_time => self.stopping_time
          }
        ]
      )

      self.statistic = events.size
    end
  end

end
