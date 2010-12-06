class ConceptsController < ApplicationController

	def graph
		@concepts = Concept.all
		@edges = ConceptEdge.all
		render :layout => false
	end
	
  def refresh_meta
    refresh_meta_data
    flash[:notice] = 'Ontologia zaktualizowana'
    redirect_to concepts_url
  end
	def refresh_meta_in_background
		refresh_meta_data
		#flash[:notice] = 'Meta-data refreshed.'
		#redirect_to concepts_url
	end
	
	def parse_csv
		Concept.delete_all
		ConceptEdge.delete_all
		params[:csv].each_line do |line|
			concept_name, parent_name = line.strip.split(';')
			concept = Concept.find_or_create_by_name( concept_name )
			if parent_name
				parent = Concept.find_or_create_by_name( parent_name )
				ConceptEdge.create(:from => concept, :to => parent)
			end
		end
		# debugger
		ConceptEdge.abc
		refresh_meta
	end
		
  # GET /concepts
  # GET /concepts.xml
  def index
    @page_id = "concepts"
    @concepts = Concept.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @concepts }
    end
  end

  # GET /concepts/1
  # GET /concepts/1.xml
  def show
    @page_id = "concepts"
    @concept = Concept.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @concept }
    end
  end

  # GET /concepts/new
  # GET /concepts/new.xml
  def new
    @page_id = "concepts"
    @concept = Concept.new
    
    respond_to do |format|
      format.html #new.html.erb
      format.xml  { render :xml => @concept }
    end
    
  end

  # GET /concepts/1/edit
  def edit
    @page_id = "concepts"
    @concept = Concept.find(params[:id])
  end

  # POST /concepts
  # POST /concepts.xml
  def create
    @concept = Concept.new(params[:concept])
    respond_to do |format|
      if @concept.save
        refresh_meta_in_background
        flash[:notice] = 'Utworzono nowy koncept'
        format.html { redirect_to(@concept) }
        format.xml  { render :xml => @concept, :status => :created, :location => @concept }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @concept.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /concepts/1
  # PUT /concepts/1.xml
  def update
    @concept = Concept.find(params[:id])
    respond_to do |format|
      if @concept.update_attributes(params[:concept])
        refresh_meta_in_background
        flash[:notice] = 'Zapisano zmiany w koncepcie.'
        format.html { redirect_to(@concept) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @concept.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /concepts/1
  # DELETE /concepts/1.xml
  def destroy
    @concept = Concept.find(params[:id])
    @concept.destroy

    respond_to do |format|
      format.html { redirect_to(concepts_url) }
      format.xml  { head :ok }
    end
  end
  
  def experiment #tymczasowe
    session[:experiment] = { :id => params[:id], :name => params[:name], :type => params[:type] }
    redirect_to :action => 'index'
  end
  
  private 
  
  def refresh_meta_data
      Concept.all.each do |c|
      c.meta_in = Service.find(:all, :conditions => [ 'input LIKE ?', '%'+c.name+'%'] ).map(&:id)
      c.meta_out = Service.find(:all, :conditions => [ 'output LIKE ?', '%'+c.name+'%'] ).map(&:id)
      c.save
    end
  end
end