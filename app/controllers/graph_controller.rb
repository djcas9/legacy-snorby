class GraphController < ApplicationController

  def event_severity
    title = Title.new("Event Severity")

    high = Event.find(:all, :include => :sig, :conditions => ['signature.sig_priority = 1']).size
    medium = Event.find(:all, :include => :sig, :conditions => ['signature.sig_priority = 2']).size
    low = Event.find(:all, :include => :sig, :conditions => ['signature.sig_priority = 3']).size

    data = []

    pie = Pie.new
    pie.start_angle = 35
    pie.animate = true
    pie.tooltip = '#val# Evnets of #total# Total.<br>#percent# of 100%'
    pie.colours = ["#adffa2", "#f8f9a4", "#fb9c9c"]

    data << PieValue.new(low, "Low Severity") unless low == 0
    data << PieValue.new(medium, "Medium Severity") unless medium == 0
    data << PieValue.new(high, "High Severity") unless high == 0

    pie.values  = data

    chart = OpenFlashChart.new
    chart.title = title
    chart.set_bg_colour('#FFFFFF')
    chart.add_element(pie)

    chart.x_axis = nil

    render :text => chart.to_s
  end

  def sensor_information
    @sensors ||= Sensor.all :include => [:events, :sensor]
    data = []
    title = Title.new("Sensor Information")

    pie = Pie.new

    for sensor in @sensors
      data << PieValue.new(sensor.events.size, "#{sensor.hostname}") unless sensor.events.size <= 1
    end

    pie.start_angle = 35
    pie.animate = true
    pie.tooltip = '#val# of #total#<br>#percent# of 100%'
    pie.colours = ["#adffa2", "#f8f9a4", "#fb9c9c"]
    pie.values  = data

    chart = OpenFlashChart.new
    chart.title = title
    chart.set_bg_colour('#FFFFFF')
    chart.add_element(pie)

    chart.x_axis = nil

    render :text => chart.to_s
  end


  def category_information
    @categories ||= SigClass.all
    data = []
    title = Title.new("Category Information")

    pie = Pie.new

    data << PieValue.new(Event.find(:all, :include => :sig, :conditions => ['signature.sig_class_id = 0']).size, "Unclassified")

    if @categories.size < 5
      for c in @categories
        data << PieValue.new(c.events_for_category, "#{c.sig_class_name}") unless c.events_for_category < 3
      end
    else
      for c in @categories
        data << PieValue.new(c.events_for_category, "#{c.sig_class_name}") unless c.events_for_category < 20
      end
    end

    pie.start_angle = 35
    pie.animate = true
    pie.tooltip = '#val# Evnets of #total# Total.<br>#percent# of 100%'
    pie.colours = ["#fb9c9c", "#f8f9a4", "#adffa2"]
    pie.values  = data

    chart = OpenFlashChart.new
    chart.title = title
    chart.set_bg_colour('#FFFFFF')
    chart.add_element(pie)

    chart.x_axis = nil

    render :text => chart.to_s
  end

end
