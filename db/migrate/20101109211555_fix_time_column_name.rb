class FixTimeColumnName < ActiveRecord::Migration
  def self.up
    rename_column :services, :time, :response_time
  end

  def self.down
    rename_column :services, :response_time, :time
  end
end
