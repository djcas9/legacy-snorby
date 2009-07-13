class SearchesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_search_keywords]

  def new
    @search = Search.new
  end

  def create
    @search = Search.new(params[:search])
    if @search.save
      if @search.events.empty?
        flash[:error] = "Sorry! No results found."
      else
        flash[:notice] = "Successfully submitted search and found #{@search.events.size} results."
      end
      redirect_to @search
    else
      flash[:notice] = "Something is not right here!"
      render :action => 'new'
    end
  end

  def show
    @search = Search.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf
      format.csv
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
    @sigs = Event.all_uniq_signatures_like(params[:search][:keywords])
    render :partial => 'keywords'
  end
end
