module GoogleCharts
  class ImageLineChart < GoogleVizualisation
    def initialize(options = {})
      @viz_type = "imagelinechart"
      @class_name = "ImageLineChart"    
      super(options)
    end
  end
end