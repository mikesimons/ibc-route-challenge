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
    @entry = Entry.shortest_for_dataset(@dataset).first if @dataset.open? and @dataset.entries.count > 0

    respond_to do |format|
      format.html
      format.js
      format.csv { send_data "#{'"Landmark","Longitude","Latitude"'}\n#{@dataset.data}", :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=dataset-#{@dataset.id}.csv" }
    end
  end
end
