class HomeController < ApplicationController

  helper :all

  def index
    @entry = Entry.shortest
    @colour = "ff0000"
  end

  def route
    @entry = Entry.find(params[:id])
    @colour = "ff0000"
    render :action => :index
  end

  def entry
    @entry = Entry.new(params[:entry])
    if @entry.save
      redirect_to route_path(@entry.id)
    else
      render :action => :index
    end
  end
end
