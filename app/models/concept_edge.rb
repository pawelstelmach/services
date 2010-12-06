class ConceptEdge < ActiveRecord::Base
	
	belongs_to :from, :class_name => 'Concept', :foreign_key => 'from_id'
    belongs_to :to, :class_name => 'Concept', :foreign_key => 'to_id'
	
	def self.abc
		k = 2.0 # parametr algorytmu
		all.each do |edge|
			length = 1 + 1.0 / ( k ** edge.to.edges_to_root.size.to_f )
			edge.update_attribute :length, length
		end
	end
	
end
