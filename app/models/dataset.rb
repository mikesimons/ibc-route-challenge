require "fastercsv"

class Dataset < ActiveRecord::Base
  has_many :entries
  validates_presence_of :name, :data
  validate :data_is_valid_format

  named_scope :in_entry_order, :include => :entries, :group => :id, :order => "COUNT(*)"

  def data_as_array
    rows = []
    FasterCSV.parse(self.data).each do |r|
      rows << r.to_a
    end
    rows
  end

  def data_as_hash
    nodes = {}
    FasterCSV.parse(self.data).each do |r|
      nodes[r[0].downcase] = { :lat => r[1].to_f, :lon => r[2].to_f }
    end
    nodes
  end

  private

  def data_is_valid_format
    begin
      FasterCSV.parse(self.data) do |r|
        errors.add :data, "doesn't match the required three column (Landmark, Lat, Lon) format" unless r.length == 3
      end
    rescue FasterCSV::MalformedCSVError
      errors.add :data, "is not valid CSV data"
    end
  end
end
