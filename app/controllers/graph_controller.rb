class GraphController < ApplicationController

  def pie_event_severity
    title = Title.new("Event Severity")

    data = []

    pie = Pie.new
    pie.start_angle = 35
    pie.animate = false
    pie.tooltip = '#val# Events of #total# Total.<br>#percent# of 100%<br>'
    pie.colours = ["#adffa2", "#f8f9a4", "#fb9c9c"]

    data << PieValue.new(params[:low].to_i, "Low Severity") unless params[:low].to_i == 0
    data << PieValue.new(params[:medium].to_i, "Medium Severity") unless params[:medium].to_i == 0
    data << PieValue.new(params[:high].to_i, "High Severity") unless params[:high].to_i == 0

    pie.values  = data

    chart = OpenFlashChart.new
    chart.title = title
    chart.set_bg_colour('#FFFFFF')
    chart.add_element(pie)

    chart.x_axis = nil

    render :text => chart.to_s
  end

  def bar_event_severity
    data = []
    data_labels = []
    unless params[:high].blank?
      data << params[:high].to_i
      data_labels << "High Severity"
    end
    unless params[:medium].blank?
      data << params[:medium].to_i
      data_labels << "Medium Severity"
    end
    unless params[:low].blank?
      data << params[:low].to_i
      data_labels << "Low Severity"
    end

    x = XAxis.new
    x.grid_colour= '#FFFFFF'
    x.set_3d 5
    x.offset= true
    x.colour= '#909090'
    x.labels= data_labels

    y = YAxis.new
    y.grid_colour= '#FFFFFF'


    if params[:all].to_i >= 50000
      y.set_range(0, params[:all].to_i, 10000)
    elsif params[:all].to_i >= 10000
      y.set_range(0, params[:all].to_i, 5000)
    elsif params[:all].to_i >= 5000
      y.set_range(0, params[:all].to_i, 1000)
    elsif params[:all].to_i >= 1000
      y.set_range(0, params[:all].to_i, 500)
    else
      y.set_range(0, params[:all].to_i, 100)
    end

    bar = Bar3d.new
    #bar.set_values(@data)

    bar.values= data
    bar.colour= '#28d2fc'
    bar.tooltip = '#val# Events'

    chart = OpenFlashChart.new
    chart.title= Title.new('Event Severity')
    chart << bar
    chart.bg_colour = '#FFFFFF'
    chart.x_axis= x
    chart.y_axis= y
    render :text => chart.render
  end



end
