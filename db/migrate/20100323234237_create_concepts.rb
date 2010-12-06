class CreateConcepts < ActiveRecord::Migration
  def self.up
    create_table :concepts do |t|
      t.string :name
      t.integer :parent_id
      t.text :meta_in
      t.text :meta_out

      t.timestamps
    end
  end

  def self.down
    drop_table :concepts
  end
end
