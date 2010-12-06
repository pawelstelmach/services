class AddMissingFileds < ActiveRecord::Migration
  def self.up
        add_column :services, :cost, :integer
        add_column :services, :time, :integer
        add_column :services, :availability, :float
        add_column :services, :succesful, :float
        add_column :services, :reputation, :integer
        add_column :services, :frequency, :integer
  end

  def self.down
        remove_column :services, :frequency
        remove_column :services, :reputation
        remove_column :services, :succesful
        remove_column :services, :availability
        remove_column :services, :time
        remove_column :services, :cost
  end
end
