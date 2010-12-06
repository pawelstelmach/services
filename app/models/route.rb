class Route
	
	attr_accessor :concepts, :length

	def marshal_dump
		{'concepts' => concepts.map(&:id).join(','), 'length' => length}
	end

	def marshal_load(data)
		self.concepts = Concept.find( data['concepts'].split(',') )
		self.length = data['length']
	end
	
end