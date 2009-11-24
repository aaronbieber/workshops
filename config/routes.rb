ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

	map.connect '', :controller => 'upcoming', :action => 'view'

  #map.connect 'admin/:object/:action/:id', :controller => 'admin'
  #map.connect 'admin', :controller => 'admin', :object => 'home', :action => 'view'
  
  map.connect 'read/:name', :controller => 'pages', :action => 'view'
  map.connect 'pages/:action/:id', :controller => 'pages'
  map.connect 'workshop/:year/:month/:ident', :controller => 'register', :action => 'view'
  #map.connect ':year/:month/:ident/:action', :controller => 'register'

	#map.connect 'register/:year/:month/:ident', :controller => 'register', :action => 'view'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  #map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  #map.connect ':controller/:action/:id.:format'

  map.connect ':controller/:action/:id'
  #map.connect ':controller/:action'
end
