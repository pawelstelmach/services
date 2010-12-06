class Concept < ActiveRecord::Base
	
	has_many :outgoing_edges, :class_name => 'ConceptEdge', :foreign_key => 'from_id', :include => :to
	has_many :incoming_edges, :class_name => 'ConceptEdge', :foreign_key => 'to_id', :include => :from
	has_many :outgoing_nodes, :through => :outgoing_edges, :source => :to
	has_many :incoming_nodes, :through => :incoming_edges, :source => :from
	serialize :meta_in
	serialize :meta_out

	def parents; outgoing_nodes end
	def children; incoming_nodes end
	def to_s; name end
  def parents=(nodes)
    self.parents.clear
    parent = Concept.find(:first, :conditions => {:name => nodes})
    self.parents << parent if parent
  end  
	
	def distance_to( concept )
		me = edges_to_root
		him = concept.edges_to_root
		route = (me | him) - (me & him) # XOR
		route.inject(0) { |memo, edge| memo += edge.length }
	end

	def edges_to_root
		current_concept = self
		edges = []
		while current_concept.parents.count == 1 do
			edges << ConceptEdge.find_by_from_id_and_to_id( current_concept.id, current_concept.parents.first.id )
			current_concept = current_concept.parents.first
		end
		edges
	end

	def sim_to_dist( podobienstwo )
		p = 0.2
		1.0 / (p * podobienstwo.to_f) - 1.0 / p
	end

	def pobierz_dzieci_sem( podobienstwo=1, starting_node = self )
		self.children.select { |c| (starting_node.distance_to c) < sim_to_dist( podobienstwo ) }.inject( [self] ) do |memo, con|
			memo << con.pobierz_dzieci_sem( podobienstwo, starting_node )
		end.flatten.uniq
	end
	
	def pobierz_rodzicow_sem( podobienstwo=1, starting_node = self )
		self.parents.select { |c| (starting_node.distance_to c) < sim_to_dist( podobienstwo ) }.inject( [self] ) do |memo, con|
			memo << con.pobierz_rodzicow_sem( podobienstwo, starting_node )
		end.flatten.uniq
	end

	def pobierz_otoczenie_sem( podobienstwo=1 )
		( pobierz_dzieci_sem(podobienstwo) + pobierz_rodzicow_sem(podobienstwo) ).uniq
	end

	def pobierz_dzieci( k=1 )
		return self if k == 0
		self.children.inject( [ self ] ) do |memo, el| 
			memo << el.pobierz_dzieci( k-1 )
		end.flatten.uniq
	end
	
	def pobierz_rodzicow( k=1 )
		return self if k == 0
		self.parents.inject( [ self ] ) do |memo, el| 
			memo << el.pobierz_rodzicow( k-1 )
		end.flatten.uniq
	end
	
	def pobierz_otoczenie( k=1 )
		( pobierz_dzieci(k) + pobierz_rodzicow(k) ).uniq
	end
	
	def is_child_of?( x, steps_up = 100 )
		self.pobierz_rodzicow( steps_up ).include? x
	end
	
end