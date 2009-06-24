class PagesController < ApplicationController

  def welcome
  end
  
  def dashboard
    @events ||= Event.all
    @uniq_events ||= Event.all :group => 'signature'
    @uniq_source ||= Iphdr.all :group => 'ip_src'
    @uniq_dest ||= Iphdr.all :group => 'ip_dst'
    @sigs ||= Signature.all
    @sensors ||= Sensor.all
  end

  def clean_out_database
    @events = Event.find(:all)
    @events.each do |e|
      e.destroy
    end
  end

end
