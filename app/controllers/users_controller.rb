class UsersController < ApplicationController
  before_filter :require_user, :only => [:show, :edit, :update]
  before_filter :require_admin, :only => [:index, :new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      if params[:user][:avatar].blank?
        flash[:notice] = "New User Successfully Created!"
        redirect_to settings_path
      else
        render :action => "crop"
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      if params[:user][:avatar].blank?
        flash[:notice] = "User Updated Successfully!"
        redirect_to settings_path
      else
        render :action => "crop"
      end
    else
      render :action => 'edit'
    end
  end

end
