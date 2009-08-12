require 'digest/sha1'

module GoogleCharts
  class GoogleVizualisation
  
    @@column_types = { String => 'string', Float => "number", Date => "date"}
    attr_accessor :uid

    def initialize(options = {})
      @columns = {}
      @max_dataset_size = 0
      @column_number = 0
      @options = options
      @uid = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
  
    def width 
      @options[:width]
    end
  
    def height
      @options[:height]
    end
  
    def format_options(options)
      unless options.empty?
        option_string = ", {"
        options.each do |option, value|
          opt = value.kind_of?(String) ? "#{value.dump}" : value
          option_string << "#{option}: #{opt},"
        end
        option_string =  option_string.chop + "}"
      else
        option_string = "{}"
      end
      return option_string
    end
  
    # name must be unique
    def add_column(name, type)
      @columns[name] = {:type => type, :column_number => @column_number, :values => []}
      @column_number += 1
    end

    def add_values(column, values)
      values.each { |v| @columns[column][:values] << v }
      @max_dataset_size = values.size > @max_dataset_size ? values.size : @max_dataset_size
    end
  
    def add_value(column, value)
      @columns[column][:values] << value
    end
  
    def render_drawChart()
      @value = <<-eos
        <script type="text/javascript"> 
        google.load("visualization", "1", {packages:["#{@viz_type}"]});
        google.setOnLoadCallback(drawChart);
      eos

      @value << <<-eos
      function drawChart() {
        var data = new google.visualization.DataTable();
      eos
    
      @columns.sort {|a,b| a[1][:column_number] <=> b[1][:column_number]}.each do |column|
        if column[1][:type] == "annotation"
          @value << "data.addColumn('string','title#{column[1][:column_number]}');\n"
          @value << "data.addColumn('string','title#{column[1][:column_number]+1}');\n"
        else
          @value << "data.addColumn('#{@@column_types[column[1][:type]]}','#{column[0]}');\n"
        end
      end
        
      @value << "data.addRows(#{@max_dataset_size});\n"

      @columns.each_key do |key|
        if @columns[key][:type] == "annotation"
          @value << "data.setValue(#{@columns[key][:row]},#{@columns[key][:column_number]},'#{@columns[key][:title]}');\n"
          @value << "data.setValue(#{@columns[key][:row]},#{@columns[key][:column_number]+1},'#{@columns[key][:text]}');\n"
        else
          cp = 0
          @columns[key][:values].each do |val|
            case @columns[key][:type].to_s
            when "Date"
              @value << "data.setValue(#{cp},#{@columns[key][:column_number]},new Date(#{val.year},#{val.month}, #{val.day}));\n"
            when "String"
              @value << "data.setValue(#{cp},#{@columns[key][:column_number]},'#{val}');\n"
            else
              @value << "data.setValue(#{cp},#{@columns[key][:column_number]},#{val});\n"
            end
            cp += 1
          end
        end
      end
      @value << <<-eos
          var chart = new google.visualization.#{@class_name}(document.getElementById('#{@uid}'));
          chart.draw(data#{format_options(@options)});
        }
      </script>
      eos
    end
  
    def render
      render_drawChart
      @value
    end
  
    alias_method :to_s, :render
  end
end