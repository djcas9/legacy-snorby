class CommentsController < ApplicationController

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
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to @comment
    else
      render :action => 'edit'
    end
  end

  def destroy
    @comment = @event.comments.find(params[:comment])
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
