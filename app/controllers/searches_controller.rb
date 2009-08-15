class SearchesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_search_keywords, :auto_complete_for_search_ip_src, :auto_complete_for_search_ip_dst]

  def index
    @searches = Search.paginate(:page => params[:page], :per_page => 20, :order => 'created_at DESC', :conditions => 'show_search = true')
  end

  def new
    @search = Search.new
  end

  def create
    @search = Search.new(params[:search])
    @search.title = "Search Query Performed on #{Time.now.strftime('%B %d %Y - %I:%M:%S %p')}"
    @search.show_search = false
    if @search.save
      redirect_to @search
    else
      render :action => 'new'
    end
  end
  
  def edit
    @search = Search.find(params[:id])
  end
  
  def update
    @search = Search.find(params[:id])
    @search.show_search = true
    if @search.update_attributes(params[:search])
      redirect_to @search
    else
      render :action => 'edit'
    end
  end

  def remove_all_results
    @search = Search.find(params[:id])
    spawn do
      @search.events.each do |event|
        event.destroy
      end
      CalcCache.update_cache
    end
    flash[:notice] = "Removing all matching results. This could take time depending on the result count."
    redirect_to new_search_path
  end

  def show
    @search = Search.find(params[:id])
    @events = @search.page_events(params[:page])
    respond_to do |format|
      format.html
      format.js
      format.xml { render :xml => @search.events }
    end
  end
  
  def destroy
    @search = Search.find(params[:id])
    @search.destroy
    redirect_to searches_path
  end

  def delete_multiple
    unless params[:search_ids].nil?
      @search = Search.find(params[:search_ids])
      @search.each do |search|
        search.destroy
      end
      flash[:notice] = "Searches Successfully Removed."
      redirect_to searches_path
    else
      flash[:error] = "No Search was selected."
      redirect_to searches_path
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
    :conditions => ['signature.sig_name LIKE ?', "%#{params[:q]}%"],
    :select => "DISTINCT sig_name", :order => "sig_name"  )
    render :partial => 'keywords'
  end

  def auto_complete_for_search_ip_src
    @src_ips = Iphdr.find(:all,
    :conditions => ['inet_ntoa(ip_src) LIKE ?', "%#{params[:q]}%"], :select => "DISTINCT ip_src")
    render :partial => 'ip_src'
  end

  def auto_complete_for_search_ip_dst
    @dst_ips = Iphdr.find(:all,
    :conditions => ['inet_ntoa(ip_dst) LIKE ?', "%#{params[:q]}%"], :select => "DISTINCT ip_dst")
    render :partial => 'ip_dst'
  end

end
