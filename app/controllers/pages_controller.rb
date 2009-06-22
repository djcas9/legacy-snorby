class PagesController < ApplicationController

  def welcome
  end

  def clean_out_database
    @events = Event.find(:all)
    @events.each do |e|
      e.destroy
    end
  end

end
