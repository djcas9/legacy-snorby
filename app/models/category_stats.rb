class CategoryStats < CachedStats

  def initialize(attributes={})
    super(attributes.merge(:duration => :forever))
  end

  #
  # Calculates the statistics for all events matching a category of
  # Signature.
  #
  def calculate!
    super do
      self.statistic = Event.count(:signature => self.sig_id)
    end
  end

  #
  # Adjusts the Category statistics if the event matches the Signature
  # category and is being removed.
  #
  def adjust(event)
    if self.sig_id == event.signature
      self.statistic -= 1
      save!
    end
  end

end
