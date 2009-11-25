class UniqueAddsStats < CachedStats

  #
  # Calculates the statistics of all previously seen unique IP addresses.
  #
  def calculate!
    super do
      sources = Iphdr.find(
        :all,
        :joins => :event,
        :group => 'ip_src',
        :conditions => [
          'event.timestamp >= :starting_time AND event.timestamp < :stopping_time',
          {
            :starting_time => self.starting_time,
            :stopping_time => self.stopping_time
          }
        ]
      ).uniq
      
      dests = Iphdr.find(
        :all,
        :joins => :event,
        :group => 'ip_dst',
        :conditions => [
          'event.timestamp >= :starting_time AND event.timestamp < :stopping_time',
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
