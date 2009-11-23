class SensorCountStats < CachedStats

  def initialize(attributes={})
    super(attributes.merge(:duration => :forever))
  end

  #
  # Calculates the statistics for all events reported by a Sensor.
  #
  def calculate!
    super do
      self.statistic = Event.count(:sid => self.sid)
    end
  end

  #
  # Adjusts the Sensor Event count statistics, if the given _event_
  # belongs to the Sensor and is being removed.
  #
  def adjust(event)
    if self.sid == event.sid
      self.statistic -= 1
      save!
    end
  end

end
