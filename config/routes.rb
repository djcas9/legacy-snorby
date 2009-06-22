ActionController::Routing::Routes.draw do |map|
  
  map.welcome "/welcome", :controller => 'pages', :action => 'welcome'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
