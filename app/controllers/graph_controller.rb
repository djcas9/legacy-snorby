class GraphController < ApplicationController

  def pie_event_severity
    data = []
    data_labels = []
    %w(High Medium Low).each do |x|
      sym = x.downcase.to_sym
      unless params[sym].blank?
        data << params[sym].to_i
        data_labels << "#{x} Severity"
      end
    end

    pie = Pie.new
    pie.on_click = 'alert(blah)'
    pie.start_angle = 35
    pie.animate = true
    pie.tooltip = '#val# Events of #total# Total.<br>#percent# of 100%<br>'

    colours = ['#fb9c9c', '#f8f9a4', '#adffa2']
    values = []
    
    [params[:high].to_i, params[:medium].to_i, params[:low].to_i].each_with_index do |v,i|
      case i
      when 0
        p = PieValue.new(v, "High Severity")
        p.on_click = "#{severity_url(:severity_id => i+1)}"
        p.colour = colours[i]
        values << p
      when 1
        p = PieValue.new(v, "Medium Severity")
        p.on_click = "#{severity_url(:severity_id => i+1)}"
        p.colour = colours[i]
        values << p
      when 2
        p = PieValue.new(v, "Low Severity")
        p.on_click = "#{severity_url(:severity_id => i+1)}"
        p.colour = colours[i]
        values << p
      end
    end

    pie.values  = values

    chart = OpenFlashChart.new
    chart.title = Title.new("Event Severity - Pie Chart")
    chart.set_bg_colour('#FFFFFF')
    chart.add_element(pie)

    chart.x_axis = nil

    render :text => chart.to_s
  end

  def bar_event_severity
    data = []
    data_labels = []
    %w(High Medium Low).each do |x|
      sym = x.downcase.to_sym
      unless params[sym].blank?
        data << params[sym].to_i
        data_labels << "#{x} Severity"
      end
    end
 
    colours = ['#fb9c9c', '#f8f9a4', '#adffa2']
    values = []
 
    bar = Bar3d.new
    [params[:high].to_i, params[:medium].to_i, params[:low].to_i].each_with_index do |v,i|
      b = BarValue.new(v)
      b.colour = colours[i]
      b.tooltip = '#val# Events'
      b.on_click = "#{severity_url(:severity_id => i+1)}"
      values << b
    end
    bar.values = values
 
    x = XAxis.new
    x.grid_colour= '#FFFFFF'
    x.set_3d 5
    x.offset= true
    x.colour= '#909090'
    x.labels = data_labels
 
    y = YAxis.new
    y.grid_colour= '#FFFFFF'
 
    highest = []
    highest = [params[:high].to_i, params[:medium].to_i, params[:low].to_i].sort!
    y.set_range(0, highest.last, ((highest.last/100).round*100)/10)
 
    chart = OpenFlashChart.new
    chart.title= Title.new('Event Severity - Bar Chart')
    chart.bg_colour = '#FFFFFF'
    chart.x_axis= x
    chart.y_axis= y
    chart.elements = [bar]
    render :text => chart.render
  end

end
