class SettingsController < ApplicationController
  before_filter :require_admin, :only => [:sensor_delete_multiple, :user_delete_multiple]

  def index
    @user = @current_user
    @settings = Setting.all
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
      @sensor.events.each do |event|
        event.destroy
      end
      CalcCache.update_cache
    end
    flash[:notice] = "Sensor events successfully removed!"
    redirect_to settings_path
  end

  def sensor_delete_multiple
    unless params[:sensor_ids].nil?
      @sensors = Sensor.find(params[:sensor_ids])
      spawn do
        @sensors.each do |sensor|
          sensor.destroy
        end
        CalcCache.update_cache
      end
      flash[:notice] = "Sensor(s) successfully removed! - Please Restart Snort!"
      redirect_to settings_path
    else
      flash[:error] = "No Sensor was selected."
      redirect_to settings_path
    end
  end

  def user_delete_multiple
    @users = User.find(params[:user_ids])
    @users.each do |user|
      user.destroy
    end
    flash[:notice] = "User(s) successfully removed!"
    redirect_to settings_path
  end

end
