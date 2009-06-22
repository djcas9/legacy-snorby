ActionController::Routing::Routes.draw do |map|
  
  map.welcome "/welcome", :controller => 'pages', :action => 'welcome'
  map.clean "/clean", :controller => 'pages', :action => 'clean_out_database'
  map.resources :events
  map.root :events
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id', :id => /\w+(,\w+)*/
end
