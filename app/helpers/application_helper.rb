# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
end

class Fixnum
	
	def uniq_randoms_from( range )
		array = range.to_a
		@output = []
		self.times do
			element = array[rand(array.count)]
			@output << array.delete( element )
		end
		@output
	end
	
	def uniq_randoms_from_v2( range )
		array = range.to_a
		(1..self).collect { |i| array.delete( array[rand(array.count)] ) }
	end
	
end

class Range
	
	def uniq_randoms_from( range )
		arr = self.to_a
		arr[rand(arr.size)].uniq_randoms_from( range )
	end
	
end