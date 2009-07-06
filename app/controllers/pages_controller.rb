class PagesController < ApplicationController

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
  
  def credits
  end

end
