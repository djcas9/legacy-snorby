class PagesController < ApplicationController

  def dashboard

    @calc = CalcCache.find(1)

    @g_event_severity ||= open_flash_chart_object(400,200, pie_event_severity_graph_url(:high => @calc.high_severity, :medium => @calc.medium_severity, :low => @calc.low_severity))
    @g_category_information ||= open_flash_chart_object(400,200, bar_event_severity_graph_url(:high => @calc.high_severity, :medium => @calc.medium_severity, :low => @calc.low_severity, :all => @calc.total_event_count))

    @high ||= @calc.high_severity
    @medium ||= @calc.medium_severity
    @low ||= @calc.low_severity

    @events = @calc.total_event_count
    @uniq_events = @calc.unique_event_count
    @uniq_adds = @calc.unique_address_count
    @categories ||= SigClass.all
    @sensors ||= Sensor.all :include => :events, :order => 'sid ASC'
  end

  def credits
  end

  def category
    unless params[:category_id].to_i == 0
      @category = SigClass.find(params[:category_id].to_i)
    end
    @events = Event.all_for_category(:c_id => params[:category_id].to_i).paginate(:page => params[:page], :per_page => 10)
  end

  def events_for_sensor
    @events = Event.events_for_sensor(params[:sensor]).paginate(:page => params[:page], :per_page => 10)
  end

  def severity
    @events = Event.events_for_severity(params[:severity]).paginate(:page => params[:page], :per_page => 20)
  end

end
