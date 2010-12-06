class ServicesController < ApplicationController
	
  def parse_csv
		Service.delete_all
		params[:csv].each_line do |line|
			s_name, s_desc, s_in, s_out, s_cost, s_time = line.strip.split(';')
			1.times do
				Service.create!( 
					:name => s_name,
					:description => s_desc,
					:input => s_in.split(',').map{ |t| t.strip }.sort.join(','),
					:output => s_out.split(',').map{ |t| t.strip }.sort.join(','),
					:cost => s_cost.to_i,# + rand(4),
					:response_time => s_time.to_i,# + rand(3),
				    :availability => rand,
				    :succesful => rand,
				    :reputation => rand,
				    :frequency => rand
				)
			end
		end
		redirect_to :action => :index unless @dont_render
	end

	def service_data
		{
			:name => Faker::Company.catch_phrase(),
			:cost => rand(9)+1,
			:response_time => rand(9)+1,
			:availability => rand,
			:succesful => rand,
			:reputation => rand,
			:frequency => rand
		}
	end
	
	def bad_concepts
		['klient fakturowany', 'klient bez umowy', 'klient z umowa', 'klient obslugiwany', 'klient nieobslugiwany']
	end

	def run_all
		@dont_render = true
		@data = []
		exact_match
		plugin
		exact_match_2
		plugin_2
		exact_match_3
		plugin_3
		render :text => @data
	end
	
	def testuj_wybrane
		params[:input] = params[:input].split(',').map{ |t| t.strip }.sort.join(',')
		params[:output] = params[:output].split(',').map{ |t| t.strip }.sort.join(',')
		@dont_render = true
		@data = []
		params[:csv] = File.read("#{RAILS_ROOT}/public/uslugi.csv")
		parse_csv
		Concept.all.each do |c|
			c.meta_in = Service.find(:all, :conditions => [ 'input LIKE ?', '%'+c.name+'%'] ).map(&:id)
			c.meta_out = Service.find(:all, :conditions => [ 'output LIKE ?', '%'+c.name+'%'] ).map(&:id)
			c.save
		end
		if params[:e1]: exact_match; end 
		if params[:p1]: plugin; end
		if params[:e2]: exact_match_2; end
		if params[:p2]: plugin_2; end
		if params[:e3]: exact_match_3; end
		if params[:p3]: plugin_3; end
		@data.map!{ |f| f.sort! { |a,b| b.dopasowanie_do(params) <=> a.dopasowanie_do(params) } }
	end

	def testuj_wielokrotnie_filtry
		params[:input] = params[:input].split(',').map{ |t| t.strip }.sort.join(',')
		params[:output] = params[:output].split(',').map{ |t| t.strip }.sort.join(',')
		if params[:typ] == 'exact'
			testuj_exact
		elsif params[:typ] == 'plugin'
			testuj_plugin
		end
	end

	def testuj_exact
		tab = []
		tab << "N;R;T1;T2;T3"
		r_range = (eval(params[:r]).is_a? Enumerable) ? eval(params[:r]) : (20..80).step(30)
		n_range = (eval(params[:n]).is_a? Enumerable) ? eval(params[:n]) : (1000..2500).step(500)
		@testing = true
		r_range.each do |r|
			n_range.each do |n|
				wypelnij_baze_exact_match( n, r )
				
				Concept.all.each do |c|
					c.meta_in = Service.find(:all, :conditions => [ 'input LIKE ?', '%'+c.name+'%'] ).map(&:id)
					c.meta_out = Service.find(:all, :conditions => [ 'output LIKE ?', '%'+c.name+'%'] ).map(&:id)
					c.save
				end
				
				t = Time.now.to_f
				ex1 = exact_match
				t1 = Time.now.to_f - t
				
				t = Time.now.to_f
				ex2 = exact_match_2
				t2 = Time.now.to_f - t
				
				t = Time.now.to_f
				ex3 = exact_match_3
				t3 = Time.now.to_f - t
				
				tab << [ n, r, t1, t2, t3 ].join(';') #ex1,ex2,ex3 
			end
		end
		render :text => tab.join("\n")
	end

	def testuj_plugin
		tab = []
		tab << "N;R;T1;T2;T3"
		r_range = (eval(params[:r]).is_a? Enumerable) ? eval(params[:r]) : (20..80).step(30)
		n_range = (eval(params[:n]).is_a? Enumerable) ? eval(params[:n]) : (1000..2500).step(500)
		@testing = true
		r_range.each do |r|
			n_range.each do |n|
				wypelnij_baze_plugin( n, r )
				
				Concept.all.each do |c|
					c.meta_in = Service.find(:all, :conditions => [ 'input LIKE ?', '%'+c.name+'%'] ).map(&:id)
					c.meta_out = Service.find(:all, :conditions => [ 'output LIKE ?', '%'+c.name+'%'] ).map(&:id)
					c.save
				end
				
				t = Time.now.to_f
				ex1 = plugin
				t1 = Time.now.to_f - t
				
				t = Time.now.to_f
				ex2 = plugin_2
				t2 = Time.now.to_f - t
				
				t = Time.now.to_f
				ex3 = plugin_3
				t3 = Time.now.to_f - t
				
				tab << [ n, r, t1, t2, t3 ].join(';') # ex1, ex2, ex3
			end
		end
		render :text => tab.join("\n")
	end
	
	def wypelnij_baze_exact_match( n, r )
		require 'faker'
		n ||= params[:n]
		r ||= params[:r]
		Service.delete_all
		relevant_count = ( n.to_i * (r.to_i / 100.0) ).round
		non_relevant_count = n.to_i - relevant_count
		all_concepts = Concept.all.map(&:name)
		
		relevant_count.times do
			extra_output = (0..4).uniq_randoms_from( bad_concepts ) # all_concepts - params[:output].split(',')
			Service.create!({
				:input => params[:input].split(',').sort.join(','),
				:output => (params[:output].split(',') + extra_output).compact.sort.join(',')
			}.merge(service_data))
		end
		
		non_relevant_count.times do
			Service.create!({
				:input => params[:input].split(',').count.uniq_randoms_from( bad_concepts ).sort.join(','),
				:output => params[:output] #.split(',').count.uniq_randoms_from( bad_concepts ).sort.join(',')
			}.merge(service_data))
		end
		
		redirect_to :action => :index unless @testing
	end
	
	def wypelnij_baze_plugin( n, r )
		require 'faker'
		n ||= params[:n]
		r ||= params[:r]
		Service.delete_all
		relevant_count = ( n.to_i * (r.to_i / 100.0) ).round
		non_relevant_count = n.to_i - relevant_count
		all_concepts = Concept.all.map(&:name)
		
		relevant_count.times do
			oddalony_input = params[:input].split(',').map { |c| Concept.find_by_name(c).pobierz_rodzicow_sem(params[:podobienstwo]).rand.name }
			oddalony_output = params[:output].split(',').map { |c| Concept.find_by_name(c).pobierz_rodzicow_sem(params[:podobienstwo]).rand.name }
			extra_output = (0..2).uniq_randoms_from( all_concepts - oddalony_output )
			Service.create!({
				:input => oddalony_input.sort.join(','),
				:output => params[:output]
				# :output => (oddalony_output + extra_output).sort.join(',')
			}.merge(service_data))
		end
		
		non_relevant_count.times do
			Service.create!({
				:input => params[:input].split(',').count.uniq_randoms_from( bad_concepts ).sort.join(','),
				:output => params[:output] #.split(',').count.uniq_randoms_from( bad_concepts ).sort.join(',')
			}.merge(service_data))
		end
		
		redirect_to :action => :index unless @testing
	end
	
	def render_services
		if @testing
			@services.size
		else
			if @dont_render
				@data << @services # "#{@services.size} -> #{@services.map(&:id).join(',')}<br/>"
			else
				@services.sort! { |a,b| a.dopasowanie_do(params) <=> b.dopasowanie_do(params) }
				render :xml => @services.to_xml #[0,params[:limit].to_i]
			end
		end
	end
	
	def search
		@services = Service.find( :all, :conditions => { :input => params[:input], :output => params[:output] }, :limit => params[:limit], :order => params[:order] )
		render :xml => @services.to_xml
	end
	
	def exact_match #OK
		@services = simple_find(:output)
		@services = @services.reject { |s| (s.input.split(',') - params[:input].split(',')).size > 0 }
		render_services
	end

	def plugin #DO TESTÓW dla usług z dobrym output a zlym input
		@services = onto_find(:output, 1, true).delete_if do |as|
			sla_concepts = params[:input].split(',').collect { |c| Concept.find_by_name( c ) }
			as_concepts = as.input.split(',').collect { |c| Concept.find_by_name( c ) }
			as_concepts.map do |c| # looking for bad stuff
				matching_c = sla_concepts.find { |x| x == c or x.is_child_of?(c) }
				# deleted_elements = 
				as_concepts.delete matching_c
				# deleted_elements ? false : true # delete succesful = don't delete
			end
			as_concepts.size > 0
		end
		render_services
	end
	
	def exact_match_2 #OK
		r = params[:input].split(',')
		@services = simple_find(:output).select { |as| as.input.split(',') == r }
		# TODO miara
		render_services
	end
	
	def plugin_2 #OK
		r = params[:input].split(',')
		@services = ( onto_find(:output, params[:podobienstwo]) & onto_find(:input, params[:podobienstwo]) ).select { |as| as.input.split(',').size == r.size }
		# TODO miara
		render_services
	end
	
	def exact_match_3 #OK
		@services = simple_find(:input) & simple_find(:output)
		# TODO miara
		render_services
	end
	
	def plugin_3 #OK
		@services = onto_find(:output, params[:podobienstwo]) & onto_find(:input, params[:podobienstwo])
		# TODO miara
		render_services
	end
	
	def simple_find( in_out )
		meta = (in_out == :input) ? :meta_in : :meta_out
		ids = params[in_out].split(',').collect{ |c| Concept.find_by_name( c ) }.map(&meta).inject{ |memo,el| memo & el }
		Service.find( ids, :order => params[:order] )
	end
	
	def onto_find( in_out, distance, plugin_1=false )
		meta = (in_out == :input) ? :meta_in : :meta_out
		concepts = params[in_out].split(',').collect{ |c| Concept.find_by_name( c ) } # pobierz koncepty pierwotne
		if plugin_1
			ids = concepts.map{ |c| c.pobierz_dzieci( distance ).map(&meta).flatten } # pobierz koncepty potomne
		else
			ids = concepts.map{ |c| c.pobierz_rodzicow_sem( distance ).map(&meta).flatten } # pobierz koncepty potomne
		end
		# debugger
		ids = ids.inject{ |memo,el| memo & el } # [[A,B,C],[C,A,D],[D,C]] => [[C]]
		s = Service.find( ids, :order => params[:order] )
		unless plugin_1
			otoczenie_wymagania = concepts.map{ |c| c.pobierz_rodzicow_sem( distance ) }.flatten
			s = s.reject do |as|
				as_concepts = as[in_out].split(',').collect{ |c| Concept.find_by_name( c ) }
				ile = as_concepts.inject(0){ |memo,c| memo += otoczenie_wymagania.include?( c ) ? 1 : 0 }
				ile < concepts.size
			end
		end
		s
	end

  # GET /services
  # GET /services.xml
  def index
    @page_id = "services"
    @services = Service.find(:all, :limit => 100)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services }
    end
  end

  # GET /services/1
  # GET /services/1.xml
  def show
    @page_id = "services"
    @service = Service.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service }
    end
  end

  # GET /services/new
  # GET /services/new.xml
  def new
    @page_id = "services"
    @service = Service.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service }
    end
  end

  # GET /services/1/edit
  def edit
    @page_id = "services"
    @service = Service.find(params[:id])
  end

  # POST /services
  # POST /services.xml
  def create
    @service = Service.new(params[:service])

    respond_to do |format|
      if @service.save
        flash[:notice] = 'Service was successfully created.'
        format.html { redirect_to(@service) }
        format.xml  { render :xml => @service, :status => :created, :location => @service }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /services/1
  # PUT /services/1.xml
  def update
    @service = Service.find(params[:id])

    respond_to do |format|
      if @service.update_attributes(params[:service])
        flash[:notice] = 'Service was successfully updated.'
        format.html { redirect_to(@service) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.xml
  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to(services_url) }
      format.xml  { head :ok }
    end
  end
  
  def experiment #tymczasowe
    session[:experiment] = { :id => params[:id], :name => params[:name], :type => params[:type] }
    redirect_to :action => 'index'
  end
end
