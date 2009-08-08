class EventsController < ApplicationController
  before_filter :require_admin, :only => [:remove_event]

  def index
    @events ||= Event.paginate(:page => params[:page], :per_page => Setting.events_per_page, 
    :include => [:sensor, :iphdr, {:sig => :sig_class }, :comments], :order => 'timestamp DESC')
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @event = Event.find(params[:id], :include => [:sensor, :iphdr, {:sig => :sig_class }, :comments, :udphdr, :icmphdr, :tcphdr])
    respond_to do |format|
      format.html
      format.pdf
      format.xml { render :xml => @event }
    end
  end

  def whois
    begin
      whois = Whois::Whois.new("#{params[:whois_host].to_s}").search_whois
      if whois
        @output = whois
      else
        @output = "An error has occurred while resolving address"
      end
      render :layout => false
    rescue Errno::ENETUNREACH
      @output = "Network is unreachable"
      render :layout => false
    rescue Whois::WhoisException
      @output = "No server found for this IPv4"
      render :layout => false
    rescue Resolv::ResolvError
      @output = "Unable to resolve address</b>"
      render :layout => false
    end
  end

  def remove_event
    @event = Event.find(params[:id], :include => [:sensor, {:sig => :sig_class }])
    @event.destroy
    respond_to do |format|
      format.html { flash[:notice] = "Event Successfully Removed!"; redirect_to events_path }
      format.js
    end
  end

  def important
    @event = Event.find(params[:id], :include => [:sensor, {:sig => :sig_class }])
    if @event.importance.present?
      imp = Importance.find(@event.id)
      imp.destroy
    else
      event = Importance.new(:sid => @event.sid, :cid => @event.cid, :important => true, :user_id => current_user.id)
      event.save!
    end
    respond_to do |format|
      format.html { redirect_to event_path(@event) }
      format.js
    end
  end

  def livelook
    @events ||= Event.livelook(params[:severity])
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

  def send_event
    @event = Event.find(params[:event_id])
    render :layout => false
  end

  def send_event_now
    @event = Event.find(params[:event_id])
    @msg = params[:msg]
    @user = current_user
    @emails = User.find(params[:user_id]).collect { |u| u.email }

    spawn do
      Pdf_for_email.make_pdf_for_event(@event)
      ReportMailer.deliver_event_report(@user, @event, @emails, @msg)
    end
    render :layout => false
  rescue
    render :inline => "<h1><%= image_tag('cross.png') %> Event Failed To Send!</h1>"
  end

end
