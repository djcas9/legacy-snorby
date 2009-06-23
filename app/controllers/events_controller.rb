class EventsController < ApplicationController

  def index
    @events = Event.paginate(:page => params[:page], :per_page => 5, :order => 'timestamp DESC')
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @event = Event.find(params[:id])
  end

end
