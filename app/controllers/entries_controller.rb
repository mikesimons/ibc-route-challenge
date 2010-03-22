class EntriesController < ApplicationController

  before_filter :dataset

  def new
    @entry = @dataset.entries.new
  end

  def create
    @entry = @dataset.entries.new(params[:entry])

    if @entry.save
      redirect_to entry_path(@entry)
    else
      render :action => :new
    end
  end

  def show
    @entry = Entry.find(params[:id])
  end

  private

  def dataset
    @dataset = Dataset.find(params[:dataset_id])
  end
end
