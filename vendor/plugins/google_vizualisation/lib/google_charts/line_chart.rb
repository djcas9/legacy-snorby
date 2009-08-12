module GoogleCharts
  class LineChart < GoogleVizualisation
    def initialize(options = {})
      @viz_type = "linechart"
      @class_name = "LineChart"    
      super(options)
    end
  end
end