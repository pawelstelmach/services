ActionController::Routing::Routes.draw do |map|
	map.resources :concepts, :collection => { 
		:graph => :get,
		:refresh_meta => :get,
		:parse_csv => :post
	}

	map.resources :services, :collection => { 
		:parse_csv => :post,
		:run_all => :post,
		:search => :get,
		:testuj_wybrane => :get,
		:testuj_wielokrotnie_filtry => :get,
		:testuj_exact => :post,
		:testuj_plugin => :post,
		:wypelnij_baze => :get,
		:wypelnij_baze_exact_match => :post,
		:wypelnij_baze_plugin => :post,
		:exact_match => :get,
		:plugin => :get,
		:exact_match_2 => :get,
		:plugin_2 => :get,
		:exact_match_3 => :get,
		:plugin_3 => :get
	}



  map.experiments '/concepts/experiment/:id/:name/:type', :controller => 'concepts', :action => 'experiment' #tymczasowe
  map.experiments '/services/experiment/:id/:name/:type', :controller => 'services', :action => 'experiment' #tymczasowe
  
  map.connect "/pages/get_photo/:id/:site", :controller => 'pages', :action => 'get_photo'
	
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

	# map.root :controller => "services", :action => "index"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
