unless Array.instance_methods.include? 'to_activity_gchart'
  Array.class_eval do
    # Returns a URL to a simple google chart the represents the activity returned by the plugin
    # 
    #   * :type => :bar/:line
    #   * :size => "200x50"
    #   * :bgcolor => "EFEFEF"
    #   * :chart_color => "336699"
    #   * :area_color => "DFEBFF" (only for :line)
    #   * :line_color => "0077CC" (only for :line)
    #   * :line_width => "2" (only for :line)
    # 
    def to_activity_gchart(options={})
      options[:type] ||= :graph
      options[:size] ||= "200x50"
      options[:bgcolor] ||= "EFEFEF"
      options[:chart_color] ||= "336699"
      options[:area_color] ||= "DFEBFF"
      options[:line_color] ||= "0077CC"
      options[:line_width] ||= "2"
      
      max_data_point = self.max{|a,b| a[:activity] <=> b[:activity] }[:activity]
      activity_str = self.map{|a| a[:activity]}.join(",")
      
      if options[:type] == :line
        return URI.escape("http://chart.apis.google.com/chart?chxt=x&chxl=#{options[:lbs]}&chs=#{options[:size]}&cht=ls&chco=#{options[:line_color]}&chm=B,DFEBFF,0,0,0&chd=t:#{activity_str}&chds=0,#{max_data_point}&chf=bg,s,#{options[:bgcolor]}&")
      elsif options[:type] == :big_line
        return "http://chart.apis.google.com/chart?chs=#{options[:size]}&cht=ls&chco=#{options[:line_color]}&chm=B,DFEBFF,0,0,0&chd=t:#{activity_str}&chds=0,#{max_data_point}&chf=bg,s,#{options[:bgcolor]}&"
      else
        return "http://chart.apis.google.com/chart?cht=bvs&chs=#{options[:size]}&chd=t:#{activity_str}&chco=#{options[:chart_color]}&chbh=a,#{options[:line_width]}&chds=0,#{max_data_point}&chf=bg,s,#{options[:bgcolor]}&"
      end
    end
  end
end