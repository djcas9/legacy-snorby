class EventsController < ApplicationController

  def index
    if params[:severity]
      @events ||= Event.paginate(:include => :sig, :page => params[:page], :per_page => 5, :conditions => ['signature.sig_priority = ?', params[:severity]], :order => 'timestamp DESC')
    else
      @events ||= Event.paginate(:page => params[:page], :per_page => 5, :order => 'timestamp DESC')
    end
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
        @output = 'No Data'
      end
      render :layout => false
    rescue Resolv::ResolvError
      @output = "Unable To Resolve Address."
      render :layout => false
    end
  end

end
