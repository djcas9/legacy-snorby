class SensorCountStats < CachedStats

  #
  # Calculates the statistics for all events reported by a Sensor.
  #
  def calculate!
    super do
      self.statistic = Event.count(:sid => self.sid)
    end
  end

end
