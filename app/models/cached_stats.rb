class CachedStats < ActiveRecord::Base

  alias last_cached updated_at

  #
  # Specifies whether the cached statistic is out of date,
  # and needs re-calculating.
  #
  def stale?
    (Time.now - self.last_cached) > self.expiration
  end

  #
  # Calculates the statistics and saves them.
  #
  def calculate!(&block)
    block.call() if block

    self.save!
  end

  alias recalculate! calculate!

end
