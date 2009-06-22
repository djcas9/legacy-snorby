class PagesController < ApplicationController
  
  def welcome
    @sensor = Sensor.all
    @event = Event.all :order => 'timestamp DESC', :limit => '20'
    @signature = Signature.all
    @tcp = Tcphdr.all
  end
  
end
