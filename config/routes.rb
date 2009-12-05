ActionController::Routing::Routes.draw do |map|

  map.resources :user_sessions
  map.resources :users
  map.resources :bills, :only => [:index, :show]
  map.resources :politicians, :only => [:index, :show]
  map.resources :reports, :only => [:index, :new]
  map.resources :users do |user|
    user.resources :reports, :controller => 'users/reports' do |report|
      report.resource :bills, :controller => 'users/reports/bills', :only => :new
    end
  end

  map.about "about", :controller => "site", :action => "about"  
  map.signup "/signup", :controller => "users", :action => "new"  
  map.login "/login", :controller => "user_sessions", :action => "new"
  map.logout "/logout", :controller => "user_sessions", :action => "destroy"  
  map.root :controller => "site", :action => 'index'
end
