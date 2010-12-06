class RemoveEdgesTableAndAddAGoodOne < ActiveRecord::Migration
  def self.up
		drop_table :edges
  end

  def self.down

  end
end
