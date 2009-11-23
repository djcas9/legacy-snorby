class UniqueEventsStats < CachedStats

  #
  # Calculates the statistics of unique events that have been previously
  # seen.
  #
  def calculate!
    super do
      events = Event.all(
        :group => 'signature',
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
