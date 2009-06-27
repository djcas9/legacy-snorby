class EventsController < ApplicationController

  def index
    @events ||= Event.paginate(:page => params[:page], :per_page => 10, :order => 'timestamp DESC', :include => [:sig, :sensor, :iphdr, :udphdr, :icmphdr, :tcphdr])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @event = Event.find(params[:id], :include => [:sig, :sensor, :iphdr, :udphdr, :icmphdr, :tcphdr])
    @source_ip ||= IPAddr.new_ntoh([@event.iphdr.ip_src].pack('N'))
    @destination_ip ||= IPAddr.new_ntoh([@event.iphdr.ip_dst].pack('N'))
  end

  def whois
    begin
      host = Resolv.getname(params[:whois_host])
      unless host.nil?
        whois = Whois.find(host)
      end
      if whois
        @output = whois.whois_output
      else
        @output = "An error has occurred while resolving address <b>#{host}</b>"
      end
      render :layout => false
    rescue ArgumentError
      @output = "Unable to resolve address <b>#{host}</b>"
      render :layout => false
    rescue Resolv::ResolvError
      @output = "Unable to resolve address <b>#{host}</b>"
      render :layout => false
    end
  end
  
  def livelook
    @events ||= Event.find(:all, :limit => 10, :order => 'timestamp DESC', :include => [:sig, :sensor, :iphdr, :udphdr, :icmphdr, :tcphdr])
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

end
