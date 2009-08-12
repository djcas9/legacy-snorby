module GoogleCharts
  class ColumnChart < GoogleVizualisation
    def initialize(options = {})
      @viz_type = "columnchart"
      @class_name = "ColumnChart"    
      super(options)
    end
  end
end