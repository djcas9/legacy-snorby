class PagesController < ApplicationController

  def force_update_cache
    spawn do
      CalcCache.update_cache
    end
    respond_to do |format|
      format.html { flash[:notice] = "Updating Snorby Cache."; redirect_to dashboard_path }
      format.js
    end
  end

  def dashboard
    @comments = Comment.recent_comments
    @calc = CalcCache.first
    @high ||= @calc.high_severity
    @medium ||= @calc.medium_severity
    @low ||= @calc.low_severity
    @events ||= @calc.total_event_count
    @uniq_events ||= @calc.unique_event_count
    @uniq_adds ||= @calc.unique_address_count
    @categories ||= @calc.category_cache
    @sensors ||= @calc.sensor_cache
    @pie_event_severity ||= open_flash_chart_object(400,200, pie_event_severity_graph_url(:high => @high, :medium => @medium, :low => @low), true, "/", "open-flash-chart-bar-clicking.swf")
    @bar_event_severity ||= open_flash_chart_object(400,200, bar_event_severity_graph_url(:high => @high, :medium => @medium, :low => @low, :all => @events), true, "/", "open-flash-chart-bar-clicking.swf")
  
  end

  def credits
  end

  def category
    unless params[:category_id].to_i == 0
      @category = SigClass.find(params[:category_id].to_i)
    end
    @events = Event.paginate(:page => params[:page], :per_page => Setting.events_per_page, :include => :sig, :conditions => ['signature.sig_class_id = ?', params[:category_id].to_i], :order => 'timestamp DESC')
  end

  def events_for_sensor
    @sensor ||= Sensor.find(params[:sensor])
    @events ||= @sensor.events.paginate(:page => params[:page], :per_page => Setting.events_per_page, :order => 'timestamp DESC')
  end

  def severity
    @events ||= Event.paginate(:page => params[:page], :per_page => Setting.events_per_page, :joins => [:comments, :importance], :include => [:sig, :sensor, :iphdr], :conditions => ['signature.sig_priority = ?', "#{params[:severity_id]}"], :order => 'timestamp DESC')
  end

end
