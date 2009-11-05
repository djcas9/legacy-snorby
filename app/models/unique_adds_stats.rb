require 'app/model/cached_stats'

class UniqueAddsStats < CachedStats

  #
  # Calculates the statistics of all previously seen unique IP addresses.
  #
  def calculate!
    super do
      sources = Iphdr.find(
        :all,
        :group => 'ip_src',
        :conditions => ['cid > ?', self.last_cid]
      ).uniq
      
      dests = Iphdr.find(
        :all,
        :group => 'ip_dst',
        :conditions => ['cid > ?', self.last_cid]
      ).uniq

      self.statistic = sources.size + dests.size
      self.last_cid = max_cid(sources + dests)
    end
  end

end
