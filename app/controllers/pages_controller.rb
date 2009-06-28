class PagesController < ApplicationController

  def welcome
  end
  
  def dashboard
    @g_event_severity ||= open_flash_chart_object(400,200,"/graph/event_severity")
    @g_category_information ||= open_flash_chart_object(400,200,"/graph/category_information")
    @events ||= Event.all :include => :sig
    @uniq_events ||= Event.all :group => 'signature'
    @uniq_adds ||= Iphdr.find(:all, :group => 'ip_src').uniq.size + Iphdr.find(:all, :group => 'ip_dst').uniq.size
    @sigs ||= Signature.all :include => :sig_class
    @categories ||= SigClass.all
    @sensors ||= Sensor.all :include => :events, :order => 'sid ASC'
  end

  def clean_out_database
    @events = Event.find(:all)
    @events.each do |e|
      e.destroy
    end
  end
  
  
  def remove_sensor
    @sensor = Sensor.find(params[:remove_sensor_id])
    if @sensor.destroy
      flash[:notice] = "Sensor destroyed successfully."
    end
    redirect_to settings_path
  end

end
