class SettingsController < ApplicationController
  before_filter :require_admin, :only => [:sensor_delete_multiple, :user_delete_multiple, :set_ids_name, :administration, :delete_events_for_sensor, :sensor_settings]
  
  def index
    @user = @current_user
  end
  
  def administration
    @settings = Setting
  end

  def save_settings
    @settings = Setting
    if @settings.update_attributes(params[:settings])
      flash[:notice] = 'Global Settings Successfully Saved.'
      redirect_to settings_path
    else
      flash[:error] = 'Error - Global Settings NOT Saved'
      redirect_to settings_path
    end
  end

  def sensor_settings
    @calc = CalcCache.find(1)
    @all = @calc.total_event_count
    @sensors = @calc.sensor_cache
  end

  def show
    @user = @current_user
    @setting = Setting.find(params[:id])
  end

  def new
    @setting = Setting.new
  end

  def my_events
    @events = Importance.all_event_for_user(current_user)
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

  def delete_events_for_sensor
    @sensor = Sensor.find(params[:sensor])
    spawn do
      @sensor.events.delete_all
      CalcCache.update_cache
    end
    flash[:notice] = "All events for sensor are being removed. This could take time depending on the event count."
    redirect_to settings_path
  end

  def sensor_delete_multiple
    unless params[:sensor_ids].nil?
      @sensors = Sensor.find(params[:sensor_ids])
      spawn do
        Sensor.destroy(@sensors)
        CalcCache.update_cache
      end
      flash[:notice] = "Sensor(s) successfully removed! -  This could take time depending on the event count. - Please Restart Snort!"
      redirect_to settings_path
    else
      flash[:error] = "No Sensor was selected."
      redirect_to settings_path
    end
  end

  def user_delete_multiple
    @remove_users = User.find(params[:user_ids])
    @remove_users.each do |rm_user|
      rm_user.destroy
    end
    flash[:notice] = "User(s) successfully removed!"
    redirect_to settings_path
  end

end
