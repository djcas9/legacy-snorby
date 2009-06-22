class EventsController < ApplicationController

  def index
    @event = Event.all :order => 'cid DESC'
  end
  
  def show
    @event = Event.find(params[:id])
  end

end
