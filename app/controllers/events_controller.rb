class EventsController < ApplicationController

  def index
    @events ||= Event.paginate(:page => params[:page], :per_page => 20, :order => 'timestamp DESC', :include => [:sig, :sensor, :iphdr, :udphdr, :icmphdr, :tcphdr])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @event = Event.find(params[:id], :include => [:sig, :sensor, :iphdr, :udphdr, :icmphdr, :tcphdr])
    @source_ip = IPAddr.new_ntoh([@event.iphdr.ip_src].pack('N'))
    @destination_ip = IPAddr.new_ntoh([@event.iphdr.ip_dst].pack('N'))
    respond_to do |format|
      format.html
      format.pdf
      format.xml { render :xml => @event }
    end
  end

  def whois
    begin
      whois = Whois::Whois.new("#{params[:whois_host]}").search_whois
      if whois
        @output = whois
      else
        @output = "An error has occurred while resolving address <b>#{params[:whois_host]}</b>"
      end
      render :layout => false
    rescue Whois::WhoisException
      @output = "No server found for this IPv4 <b>#{params[:whois_host]}</b>"
      render :layout => false
    rescue Resolv::ResolvError
      @output = "Unable to resolve address <b>#{params[:whois_host]}</b>"
      render :layout => false
    end
  end

  def get_sig_information
    begin
      @sig_data = File.open("#{RAILS_ROOT}/public/signatures/#{params[:snort_sig_id]}.txt")
      render :layout => false
    rescue Errno::ENOENT
      @sig_data = "<font color='red'><b>Not signature information found.</b></font>"
      render :layout => false
    end
  end

  def livelook
    @time = Time.now
    @events ||= Event.find(:all, :limit => 20, :order => 'timestamp DESC', :include => [:sig, :sensor, :iphdr, :udphdr, :icmphdr, :tcphdr])
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
    @emails = []
    @myteam = params[:user_id] ||= []
    @myteam.each do |m|
      @emails << User.find(m).email
    end
    #call_rake :event_mailing, :user => @user, :event => @event, :emails => @emails, :msg => @msg
    spawn do
      Pdf_for_email.make_pdf_for_event(@event)
      ReportMailer.deliver_event_report(@user, @event, @emails, @msg)
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end


end
