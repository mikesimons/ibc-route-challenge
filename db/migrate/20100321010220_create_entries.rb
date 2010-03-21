class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.text :entry
      t.integer :distance
      t.string :author
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
