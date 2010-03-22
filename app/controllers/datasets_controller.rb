class DatasetsController < ApplicationController
  def index
    @datasets = Dataset.all
  end

  def new
    @dataset = Dataset.new(params[:dataset])
  end

  def create
    @dataset = Dataset.new(params[:dataset])
    if @dataset.save
      redirect_to dataset_path(@dataset)
    else
      render :action => :new
    end
  end

  def show
    params[:id] = Dataset.first if params[:id].nil?
    @dataset = Dataset.find(params[:id])
  end
end
