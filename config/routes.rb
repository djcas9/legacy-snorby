ActionController::Routing::Routes.draw do |map|
  map.resources :settings

  map.welcome "/welcome", :controller => 'pages', :action => 'welcome'
  map.dashboard "/dashboard", :controller => 'pages', :action => 'dashboard'
  map.livelook "/livelook", :controller => 'events', :action => 'livelook'
  map.clean "/clean", :controller => 'pages', :action => 'clean_out_database'
  map.test "/test", :controller => 'graph', :action => 'index'
  map.resources :events
  map.root :dashboard
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id', :id => /\w+(,\w+)*/
end
