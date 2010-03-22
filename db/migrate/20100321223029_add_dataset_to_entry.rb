class AddDatasetToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :dataset_id, :integer, :null => false
  end

  def self.down
    remove_column :entries, :dataset_id
  end
end
