class CachedStats < ActiveRecord::Base

  #
  # Determines the time the statistic was last cached at.
  #
  def last_cached
    (self.updated_at || self.created_at || Time.now)
  end

  #
  # Specifies whether the cached statistic is out of date,
  # and needs re-calculating.
  #
  def stale?
    (Time.now >= self.expiration)
  end

  #
  # Calculates the statistics and saves them.
  #
  def calculate!(&block)
    block.call() if block
    self.expiration ||= 20.seconds.from_now
    self.save!
  end

  alias recalculate! calculate!

  #
  # Finds the largest cid value of the given _rows_.
  #
  def max_cid(rows)
    rows.max { |a,b| a.cid <=> b.cid }.cid
  end

end
