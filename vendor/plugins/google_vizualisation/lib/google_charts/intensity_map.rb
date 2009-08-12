module GoogleCharts
  class IntensityMap < GoogleVizualisation
    def initialize(options = {})
      @viz_type = "intensitymap"
      @class_name = "IntensityMap"
      super(options)   
    end
  end
end