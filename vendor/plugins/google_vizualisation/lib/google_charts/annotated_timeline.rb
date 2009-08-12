module GoogleCharts
  class AnnotatedTimeline < GoogleVizualisation
    def initialize(options = {})
      @viz_type = "annotatedtimeline"
      @class_name = "AnnotatedTimeLine"
      super(options)
    end

    def add_annotation(row, title, text)
      @options[:displayAnnotations] = true
      @columns[title] = {:type => 'annotation', :title => title, :text => text, :row => row, :column_number => @column_number }
      @column_number += 2
    end
  end
end