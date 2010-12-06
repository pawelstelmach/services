class Service < ActiveRecord::Base
	
	def dopasowanie_do( wymaganie )
		alfa1, alfa2, beta1, beta2 = 0.25, 0.25, 0.25, 0.25
		wym_input, wym_output = wymaganie[:input].split(','), wymaganie[:output].split(',')
		as_input, as_output = input.split(','), output.split(',')
		alfa1 * (( as_input.size == 0 ) ? ( 1 ) : ( wym_input.size / as_input.size )) +
		alfa2 * (( as_output.size == 0 ) ? ( 1 ) : ( wym_output.size / as_output.size )) +
		beta1 * (( wym_input.size == 0 ) ? ( 1 ) : ( najlepsze_dopasowanie( wym_input, as_input ) / wym_input.size )) +
		beta2 * (( wym_output.size == 0 ) ? ( 1 ) : ( najlepsze_dopasowanie( wym_output, as_output ) / wym_output.size ))
	end
	
	def dist_to_sim( dist )
		p = 0.2
		1.0 / ( p * dist.to_f + 1 )
	end
	
	def najlepsze_dopasowanie( wymaganie, as_in_out )
		best_sum = false
		# Budowanie matrycy potencjalnych polaczen
		link = as_in_out.map do |c|
			wymaganie.map do |wym|
				dist_to_sim( Concept.find_by_name( wym ).distance_to( Concept.find_by_name( c ) ) )
			end
		end
		perm = (1..as_in_out.size).map { |i| ( (i < wymaganie.size) ? i : 0 ) }
		perm.permute do |p|
			sum = 0
			p.each_with_index { |pos, idx| sum += link[idx][pos] }
			if (best_sum == false) or (sum > best_sum)
				best_sum = sum
				best_uklad = p
			end
		end
		best_sum
	end

end

class Array
    def permute(prefixed=[])
        if (length < 2)
            # there are no elements left to permute
            yield(prefixed + self)
        else
            # recursively permute the remaining elements
            each_with_index do |e, i|
                (self[0,i]+self[(i+1)..-1]).permute(prefixed+[e]) { |a| yield a }
            end
        end
    end
end