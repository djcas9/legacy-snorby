module GoogleCharts
  class ImageBarChart < GoogleVizualisation
    def initialize(options = {})
      @viz_type = "imagebarchart"
      @class_name = "ImageBarChart"    
      super(options)
    end
  end
end