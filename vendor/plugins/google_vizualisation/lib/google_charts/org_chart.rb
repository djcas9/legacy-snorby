module GoogleCharts
  class OrgChart < GoogleVizualisation
    def initialize(options = {})
      @viz_type = "orgchart"
      @class_name = "OrgChart"    
      super(options)
    end
  end
end