class EventsController < ApplicationController

  def index
    session[:page] = params[:page]
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
    #flash[:notice] = 'LiveLook is a nifty way to keep up-to-date with new events in realtime. Who wants to hit refresh every 5 seconds? LiveLook is currently in beta so it may get a bit bumpy.'
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

end
