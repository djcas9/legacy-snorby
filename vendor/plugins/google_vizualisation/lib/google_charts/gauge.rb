module GoogleCharts
  class Gauge < GoogleVizualisation
    def initialize(options = {})
      @viz_type = "gauge"
      @class_name = "Gauge"
      super(options)
    end
  end
end