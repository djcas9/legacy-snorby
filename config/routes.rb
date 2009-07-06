ActionController::Routing::Routes.draw do |map|
  
  map.resources :reports
  map.resources :reports, :collection => { :delete_multiple => :post }
  map.resources :settings, :collection => { :sensor_delete_multiple => :post, :user_delete_multiple => :post }
  map.resource :user_session
  map.resource :account, :controller => "users"
  map.resources :users
  map.login '/login', :controller => "user_sessions", :action => "new"
  map.logout '/logout', :controller => "user_sessions", :action => "destroy"
  
  map.welcome "/welcome", :controller => 'pages', :action => 'welcome'
  map.dashboard "/dashboard", :controller => 'pages', :action => 'dashboard'
  map.livelook "/livelook", :controller => 'events', :action => 'livelook'
  
  map.send_event "events/:event_id/send_event", :controller => 'events', :action => 'send_event'
  map.resources :events
  map.root :dashboard
  map.resources :searches
  map.resources :settings
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id', :id => /\w+(,\w+)*/
  
end
