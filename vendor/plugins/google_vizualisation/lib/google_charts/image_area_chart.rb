module GoogleCharts
  class ImageAreaChart < GoogleVizualisation
  
    def initialize(options = {})
      @viz_type = "imageareachart"
      @class_name = "ImageAreaChart"    
      super(options)
    end
  end
end