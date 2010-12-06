class AddLengthToEdge < ActiveRecord::Migration
  def self.up
    add_column :edges, :length, :float
  end

  def self.down
    remove_column :edges, :length
  end
end
