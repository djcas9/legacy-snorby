class CachedStats < ActiveRecord::Base

  #
  # Finds all cached statistics that cover the given _timestamp_.
  #
  def self.covering(timestamp)
    self.find(
      :all,
      :conditions => [
        'started_at <= :timestamp AND stopped_at > :timestamp',
        {:timestamp => timestamp}
      ]
    )
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
  #   stat.rebase(Date.today)
  #
  def rebase(start_time)
    delta = (self.stopped_at - self.started_at)

    self.started_at = start_time
    self.stopped_at = (start_time + delta)

    return self
  end

end
