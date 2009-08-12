module GoogleCharts
  class BarChart < GoogleVizualisation
    def initialize(options = {})
      @viz_type = "barchart"
      @class_name = "BarChart"    
      super(options)
    end
  end
end