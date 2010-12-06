class CreateConceptEdges < ActiveRecord::Migration
  def self.up
    create_table :concept_edges do |t|
      t.integer :from_id
      t.integer :to_id
      t.float :length

      t.timestamps
    end
  end

  def self.down
    drop_table :concept_edges
  end
end
