ActionController::Routing::Routes.draw do |map|

  map.resources :user_sessions
  map.resources :users
  map.resources :bills
  map.resources :reports
  map.resources :users do |user|
    user.resources :reports
  end

  map.about "about", :controller => "site", :action => "about"  
  map.signup "/signup", :controller => "users", :action => "new"  
  map.login "/login", :controller => "user_sessions", :action => "new"
  map.logout "/logout", :controller => "user_sessions", :action => "destroy"  
  map.root :controller => "site", :action => 'index'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
