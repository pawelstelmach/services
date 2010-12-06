class AddRoutingTableToConcept < ActiveRecord::Migration
  def self.up
    add_column :concepts, :routing_table, :text
  end

  def self.down
    remove_column :concepts, :routing_table
  end
end
