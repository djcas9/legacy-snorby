class SearchesController < ApplicationController
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
  end
end
