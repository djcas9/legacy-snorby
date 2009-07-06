class SettingsController < ApplicationController
  before_filter :require_admin, :only => [:sensor_delete_multiple]
  
  def index
    @user = @current_user
    @settings = Setting.all
    #Event.run_daily_report
    #Event.run_weekly_report
    #Event.run_monthly_report
  end
  
  def sensor_settings
    @sensors = Sensor.all(:order => 'sid ASC')
  end
  
  def show
    @user = @current_user
    @setting = Setting.find(params[:id])
  end
  
  def new
    @setting = Setting.new
  end
  
  def create
    @setting = Setting.new(params[:setting])
    if @setting.save
      flash[:notice] = "Successfully created setting."
      redirect_to @setting
    else
      render :action => 'new'
    end
  end
  
  def edit
    @setting = Setting.find(params[:id])
  end
  
  def update
    @setting = Setting.find(params[:id])
    if @setting.update_attributes(params[:setting])
      flash[:notice] = "Successfully updated setting."
      redirect_to @setting
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @setting = Setting.find(params[:id])
    @setting.destroy
    flash[:notice] = "Successfully destroyed setting."
    redirect_to settings_url
  end
  
  def sensor_delete_multiple
    @sensors = Sensor.find(params[:sensor_ids])
    @sensors.each do |sensor|
      sensor.destroy
    end
    flash[:notice] = "Sensor were successfully removed!"
    redirect_to settings_path
  end
  
end
