class SensorEventStats < CachedStats

  #
  # Calculates the statistics of sensor events that have been previously
  # seen.
  #
  def calculate!
    super do
      events = Event.all(
      :include => :sig,
      :conditions => ['sid = 2 AND cid > ?', self.last_cid]
      )

      self.statistic = events.size
      self.last_cid = max_cid(events)
    end
  end

end
