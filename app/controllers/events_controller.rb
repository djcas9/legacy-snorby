class EventsController < ApplicationController

  def index
    @events ||= Event.paginate(:page => params[:page], :per_page => 2, :order => 'timestamp DESC')
    # if params[:severity]
    #   @events ||= Event.paginate(:include => :sig, :page => params[:page], :per_page => 5, :conditions => ['signature.sig_priority = ?', params[:severity]], :order => 'timestamp DESC')
    # else
    #   @events ||= Event.all.paginate(:page => params[:page], :per_page => 10, :order => 'timestamp DESC')
    # end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def whois
    begin
      host = params[:whois_host]
      whois = Whois.find(Resolv.getname(host))
      if whois
        @output = whois.whois_output
      else
        @output = "An error has occurred while resolving address <b>#{host}</b>"
      end
      render :layout => false
    rescue Resolv::ResolvError
      @output = "Unable to resolve address <b>#{host}</b>"
      render :layout => false
    end
  end

end
