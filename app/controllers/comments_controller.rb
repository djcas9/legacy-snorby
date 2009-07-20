class CommentsController < ApplicationController
  before_filter :require_admin_or_owner, :only => [:edit, :update, :destroy]

  def require_admin_or_owner
    unless User.is_admin_or_owner(current_user, params[:id])
      store_location
      flash[:error] = "You must be an administrator to perform this task"
      redirect_to dashboard_path
      return false
    end
  end

  def create
    @event = Event.find(params[:event_id])
    @comment = @event.comments.new(params[:comment])
    @comment.user = current_user
    @comment.comment_time = "#{Time.now}"
    if @comment.save!
      respond_to do |format|
        format.html { redirect_to @event }
        format.js
      end
    else
      flash[:error] = "An error occurred while creating your comment."
      redirect_to @event
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @event = @comment.event
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to @event
    else
      render :action => 'edit'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    if @comment.destroy
      respond_to do |format|
        format.html { redirect_to @event }
        format.js
      end
    else
      flash[:error] = "An error occurred while attempting to destroy your comment."
      redirect_to @event
    end
  end
end
