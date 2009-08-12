module GoogleCharts
  class MotionChart < GoogleVizualisation
    def initialize(options = {})
      @viz_type = "motionchart"
      @class_name = "MotionChart"    
      super(options)
    end
  end
end