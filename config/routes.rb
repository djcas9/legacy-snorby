ActionController::Routing::Routes.draw do |map|
  
  map.welcome "/welcome", :controller => 'pages', :action => 'welcome'
  map.dashboard "/dashboard", :controller => 'pages', :action => 'dashboard'
  map.livelook "/livelook", :controller => 'events', :action => 'livelook'
  map.clean "/clean", :controller => 'pages', :action => 'clean_out_database'
  
  map.resources :events
  map.root :dashboard
  map.resources :searches
  map.resources :settings
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id', :id => /\w+(,\w+)*/
end
