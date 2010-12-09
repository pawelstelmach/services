class AddServiceClassToService < ActiveRecord::Migration
  def self.up
    add_column :services, :service_class, :string
  end

  def self.down
    remove_column :services, :service_class
  end
end
