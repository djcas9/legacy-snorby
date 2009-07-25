class ReportsController < ApplicationController
  #cache_sweeper :report_sweeper, :only => [:new, :create, :update, :destroy, :delete_multiple]
  before_filter :require_admin, :only => [:edit, :update, :destroy, :delete_multiple]
  #caches_action :index, :cache_path => 'report_index'

  def index
    @reports = Report.paginate(:page => params[:page], :per_page => 20, :order => 'created_at DESC')
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @report = Report.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf
      format.xml { render :xml => @report.events }
    end
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(params[:report])
    if @report.save
      redirect_to @report
    else
      render :action => 'new'
    end
  end

  def edit
    @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    if @report.update_attributes(params[:report])
      redirect_to @report
    else
      render :action => 'edit'
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy
    redirect_to reports_url
  end

  def delete_multiple
    unless params[:report_ids].nil?
      @reports = Report.find(params[:report_ids])
      @reports.each do |report|
        report.destroy
      end
      redirect_to reports_path
    else
      flash[:error] = "No Report was selected."
      redirect_to reports_path
    end
  end

  def send_report
    @report = Report.find(params[:report_id])
    render :layout => false
  end

  def send_report_now
    @report = Report.find(params[:report_id])
    @events = @report.events
    @msg = params[:msg]
    @user = current_user

    @emails = User.find(params[:user_id]).collect { |u| u.email }

    spawn do
      Pdf_for_email.make_pdf(@report, @events)
      ReportMailer.deliver_report_report(@user, @report, @emails, @msg)
    end
    render :layout => false
  end

end
