class ReportsController < ApplicationController
  before_filter :require_admin, :only => [:edit, :update, :destroy, :delete_multiple]
  
  def index
    @reports = Report.paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')
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
      format.csv
      format.xml { render :xml => @report.events }
    end
  end
  
  def new
    @report = Report.new
  end
  
  def create
    @report = Report.new(params[:report])
    if @report.save
      flash[:notice] = "Successfully created report."
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
      flash[:notice] = "Successfully updated report."
      redirect_to @report
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @report = Report.find(params[:id])
    @report.destroy
    flash[:notice] = "Successfully destroyed report."
    redirect_to reports_url
  end
  
  def delete_multiple
    @reports = Report.find(params[:report_ids])
    @reports.each do |report|
      report.destroy
    end
    flash[:notice] = "Reports were successfully removed!"
    redirect_to reports_path
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

    @emails = []
    @myteam = params[:user_id] ||= []
    @myteam.each do |m|
      @emails << User.find(m).email
    end
    
    spawn do
      Pdf_for_email.make_pdf(@report, @events)
      ReportMailer.deliver_report_report(@user, @report, @emails, @msg)
    end
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
end
