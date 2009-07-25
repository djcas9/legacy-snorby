class SearchesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_search_keywords, :auto_complete_for_search_ip_src, :auto_complete_for_search_ip_dst]
    
  def new
    @search = Search.new
  end

  def create
    @search = Search.new(params[:search])
    if @search.save
      redirect_to @search
    else
      render :action => 'new'
    end
  end

  def remove_all_results
    @search = Search.find(params[:id])
    spawn do
      @search.events.each do |event|
        event.destroy
      end
    end
    flash[:notice] = "Successfully removed matching results."
    redirect_to new_search_path
  end

  def show
    @search = Search.find(params[:id])
    @events = @search.page_events(params[:page])
    respond_to do |format|
      format.html
      format.pdf
      format.js
      format.xml { render :xml => @search.events }
    end
  end

  def send_search
    @search = Search.find(params[:search_id])
    render :layout => false
  end

  def send_search_now
    @search = Search.find(params[:search_id])
    @msg = params[:msg]
    @user = current_user

    @emails = User.find(params[:user_id]).collect { |u| u.email }

    spawn do
      Pdf_for_email.make_pdf_for_search(@search)
      ReportMailer.deliver_search_report(@user, @search, @emails, @msg)
    end
  end

  def auto_complete_for_search_keywords
    @sigs = Signature.find(:all,
    :conditions => ['signature.sig_name LIKE ?', "%#{params[:search][:keywords]}%"],
    :select => "DISTINCT sig_name", :order => "sig_name"  )
    render :partial => 'keywords'
  end

  def auto_complete_for_search_ip_src
    @src_ips = Iphdr.find(:all,
    :conditions => ['inet_ntoa(ip_src) LIKE ?', "%#{params[:search][:ip_src]}%"], :select => "DISTINCT ip_src")
    render :partial => 'ip_src'
  end

  def auto_complete_for_search_ip_dst
    @dst_ips = Iphdr.find(:all,
    :conditions => ['inet_ntoa(ip_dst) LIKE ?', "%#{params[:search][:ip_dst]}%"], :select => "DISTINCT ip_dst")
    render :partial => 'ip_dst'
  end

end
