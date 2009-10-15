class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      format.html do
        if @user_session.save
          flash[:notice] = "Login successful - Welcome back!"
          redirect_back_or_default dashboard_path
        else
          flash[:error] = "Incorrect User and/or Password."
          redirect_to login_path
        end
      end
      format.js
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to login_path
  end
end
