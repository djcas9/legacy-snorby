module GoogleCharts
  class AreaChart < GoogleVizualisation
    def initialize(options = {})
      @viz_type = "areachart"
      @class_name = "AreaChart"    
      super(options)
    end
  end
end