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
        flash[:notice] = "Successfully submitted search and found #{@search.events.size} results. <%= link_to('Printable Invoice (PDF)', search_path(@search, :format => 'pdf')) %>"
      end
      redirect_to @search
    else
      flash[:notice] = "Something is not right here!"
      render :action => 'new'
    end
  end

  def show
    @search = Search.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf
      format.csv
      format.xml { render :xml => @report.events }
    end
  end
end
