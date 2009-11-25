class CachedStats < ActiveRecord::Base

  DURATION_KEYS = {
    0 => :forever,
    1 => :daily,
    2 => :weekly,
    4 => :monthly
  }

  DURATION_NAMES = {
    :forever => 0,
    :daily => 1,
    :weekly => 2,
    :monthly => 4
  }

  def initialize(attributes={})
    if (duration_name = attributes.delete(:duration))
      attributes.merge!(:duration_key => DURATION_NAMES[duration_name])
    end

    super(attributes)
  end

  def self.full_count(attributes={})
    count_all = self.new(attributes.merge(
                      :duration => :forever,
                      :started_at => Event.oldest,
                      :stopped_at => Time.now
    ))
    count_all.calculate!
    return count_all
  end

  #
  # Clear CacheStats Table
  #
  def self.clear_cache
    self.delete_all
  end

  #
  # Initializes a new daily statistic with the given _attributes_.
  #
  def self.new_day(attributes={})
    t1 = Time.now

    return self.new(attributes.merge(
                      :duration => :daily,
                      :started_at => t1,
                      :stopped_at => t1 + 1.day
    ))
  end

  #
  # Initializes a new weekly statistic with the given _attributes_.
  #
  def self.new_week(attributes={})
    t1 = Time.now

    return self.new(attributes.merge(
                      :duration => :weekly,
                      :started_at => t1,
                      :stopped_at => t1 + 1.week
    ))
  end

  #
  # Initializes a new monthly statistic with the given _attributes_.
  #
  def self.new_month(attributes={})
    t1 = Time.now

    return self.new(attributes.merge(
                      :duration => :monthly,
                      :started_at => t1,
                      :stopped_at => t1 + 1.month
    ))
  end

  #
  # Finds all statistics that persist forever.
  #
  def self.forever
    self.find(
      :all,
      :conditions => {:duration_key => DURATION_NAMES[:forever]}
    )
  end

  #
  # Finds all daily statistics.
  #
  def self.daily
    self.find(
      :all,
      :conditions => {:duration_key => DURATION_NAMES[:daily]}
    )
  end

  #
  # Finds all weekly statistics.
  #
  def self.weekly
    self.find(
      :all,
      :conditions => {:duration_key => DURATION_NAMES[:weekly]}
    )
  end

  #
  # Finds all monthly statistics.
  #
  def self.monthly
    self.find(
      :all,
      :conditions => {:duration_key => DURATION_NAMES[:monthly]}
    )
  end

  #
  # Finds all cached statistics that cover the given _timestamp_.
  #
  #   CachedStats.covering(event.timestamp)
  #   # => [...]
  #
  def self.covering(timestamp)
    self.find(
      :all,
      :conditions => [
        '(started_at <= :timestamp AND stopped_at > :timestamp) OR duration_key = :forever',
        {
          :timestamp => timestamp,
          :forever => DURATION_NAMES[:forever]
        }
      ]
    )
  end

  #
  # Specifies the duration of the statistic.
  #
  #   stat.duration
  #   # => :daily
  #
  def duration
    DURATION_KEYS[self.duration_key]
  end

  #
  # Sets the duration to the given _name_.
  #
  #   stats.duration = :daily
  #   # => :daily
  #
  def duration=(name)
    self.duration_key = DURATION_NAMES[name]
    return name
  end

  #
  # Returns +true+ if the statistic represents timeless data, returns +false+
  # otherwise.
  #
  def forever?
    duration == :forever
  end

  #
  # Returns +true+ if the statistic represents daily data, returns +false+
  # otherwise.
  #
  def daily?
    duration == :daily
  end

  #
  # Returns +true+ if the statistic represents weekly data, returns +false+
  # otherwise.
  #
  def weekly?
    duration == :weekly
  end

  #
  # Returns +true+ if the statistic represents monthly data, returns +false+
  # otherwise.
  #
  def monthly?
    duration == :monthly
  end

  #
  # The starting point of the cached statistic.
  #
  def starting_time
    self.started_at
  end

  #
  # The stopping point for the cached statistic.
  #
  def stopping_time
    self.stopped_at
  end

  #
  # Calculates the statistics and saves them.
  #
  def calculate!(&block)
    block.call() if block

    self.save!
  end

  alias recalculate! calculate!

  #
  # Rebases the starting_time and stopping_time of the statistics using the
  # new _start_time_.
  #
  #   stat.rebase(Time.at_beginning_of_day)
  #
  def rebase(start_time)
    delta = (self.stopped_at - self.started_at)

    self.started_at = start_time
    self.stopped_at = (start_time + delta)

    return self
  end

  #
  # Adjusts the statistics, in the case where an Event has been removed.
  #
  def adjust(event)
    recalculate!
  end

end
