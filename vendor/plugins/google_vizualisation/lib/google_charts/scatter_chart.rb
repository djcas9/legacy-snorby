module GoogleCharts
  class ScatterChart < GoogleVizualisation
    def initialize(options = {})
      @viz_type = "scatterchart"
      @class_name = "ScatterChart"    
      super(options)
    end
  end
end