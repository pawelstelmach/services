class ChangeFieldsType < ActiveRecord::Migration
  def self.up
		change_column :services, :reputation, :float
		change_column :services, :frequency, :float
  end

  def self.down
  end
end
