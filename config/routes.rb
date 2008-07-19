ActionController::Routing::Routes.draw do |map|

  ## Static Pages
  map.root :controller => "browse"

  ## Administration
  map.namespace :admin do |admin|
    admin.connect "/", :controller=>"home"
    admin.resources :users, :active_scaffold => true
    admin.resources :sources, :active_scaffold => true
  end

  map.connect 'stream/uploaded_file/:username', #/:relative_filepath',
              :controller=>"stream",
              :action=>"uploaded_file"

  ## Default Routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
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

  # See how all your routes lay out with "rake routes"

end
