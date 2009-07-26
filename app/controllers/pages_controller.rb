class PagesController < ApplicationController
  before_filter :update_cache

  def update_cache
    if session[:refresh_time].nil? || session[:refresh_time] < Time.now
      Rails.cache.delete('SnorbyCalcCache')
      spawn do
        CalcCache.update_cache
      end
      session[:refresh_time] = 15.minutes.since
    end
  end

  def force_update_cache
    Rails.cache.delete('SnorbyCalcCache')
    spawn do
      CalcCache.update_cache
    end
    respond_to do |format|
      format.html { flash[:notice] = "Updating Snorby Cache."; redirect_to dashboard_path }
      format.js
    end
  end

  def dashboard
    @calc = Rails.cache.fetch('SnorbyCalcCache') { CalcCache.find(1) }
    @g_event_severity ||= open_flash_chart_object(400,200, pie_event_severity_graph_url(:high => @calc.high_severity, :medium => @calc.medium_severity, :low => @calc.low_severity))
    @g_category_information ||= open_flash_chart_object(400,200, bar_event_severity_graph_url(:high => @calc.high_severity, :medium => @calc.medium_severity, :low => @calc.low_severity, :all => @calc.total_event_count))
    @high ||= @calc.high_severity
    @medium ||= @calc.medium_severity
    @low ||= @calc.low_severity
    @events ||= @calc.total_event_count
    @uniq_events ||= @calc.unique_event_count
    @uniq_adds ||= @calc.unique_address_count
    @categories ||= @calc.category_cache
    @sensors ||= @calc.sensor_cache
  end

  def credits
  end

  def category
    unless params[:category_id].to_i == 0
      @category = SigClass.find(params[:category_id].to_i)
    end
    @events = Event.paginate(:page => params[:page], :per_page => 20, :include => :sig, :conditions => ['signature.sig_class_id = ?', params[:category_id].to_i])
  end

  def events_for_sensor
    @sensor = Sensor.find(params[:sensor])
    @events = @sensor.events.paginate(:page => params[:page], :per_page => 20)
  end

  def severity
    @events = Event.events_for_severity(params[:severity]).paginate(:page => params[:page], :per_page => 20)
  end

end
