#require 'app/model/cached_stats'

class UniqueAddsStats < CachedStats

  #
  # Calculates the statistics of all previously seen unique IP addresses.
  #
  def calculate!
    super do
      sources = Iphdr.find(
        :all,
        :group => 'ip_src',
        :conditions => [
          'timestamp >= :starting_time AND timestamp < :stopping_time',
          {
            :starting_time => self.starting_time,
            :stopping_time => self.stopping_time
          }
        ]
      ).uniq
      
      dests = Iphdr.find(
        :all,
        :group => 'ip_dst',
        :conditions => [
          'timestamp >= :starting_time AND timestamp < :stopping_time',
          {
            :starting_time => self.starting_time,
            :stopping_time => self.stopping_time
          }
        ]
      ).uniq

      self.statistic = sources.size + dests.size
    end
  end

end
