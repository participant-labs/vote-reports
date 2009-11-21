ActionController::Routing::Routes.draw do |map|

  map.resources :user_sessions
  map.resources :users do |user|
    user.resources :reports
  end
  map.resources :reports

  map.signup "/signup", :controller => "users", :action => "new"  
  map.login "/login", :controller => "user_sessions", :action => "new"
  map.logout "/logout", :controller => "user_sessions", :action => "destroy"  
  map.root :controller => "site", :action => 'index'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
