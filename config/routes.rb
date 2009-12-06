ActionController::Routing::Routes.draw do |map|

  map.resources :bills, :only => [:index, :show]
  map.resources :politicians, :only => [:index, :show]

  map.resources :user_sessions
  map.resources :users

  map.resources :reports, :only => [:index, :new]

  map.user_reports "reports/:user_id",
    :controller => 'users/reports',:action => 'index', :conditions => { :method => :get }
  map.user_reports "reports/:user_id",
    :controller => 'users/reports',:action => 'create', :conditions => { :method => :post }
  map.new_user_report  "reports/:user_id/new",
    :controller => 'users/reports', :action => 'new', :conditions => { :method => :get }
  map.user_report  "reports/:user_id/:id",
    :controller => 'users/reports', :action => 'show', :conditions => { :method => :get }
  map.user_report  "reports/:user_id/:id",
    :controller => 'users/reports', :action => 'update', :conditions => { :method => :put }
  map.user_report  "reports/:user_id/:id",
    :controller => 'users/reports', :action => 'destroy', :conditions => { :method => :delete }
  map.edit_user_report  "reports/:user_id/:id/edit",
    :controller => 'users/reports', :action => 'edit', :conditions => { :method => :get }

  map.new_user_report_bills "reports/:user_id/:report_id/bills/new",
    :controller => 'users/reports/bills', :action => 'new', :conditions => { :method => :get }

  map.about "about", :controller => "site", :action => "about"  
  map.signup "/signup", :controller => "users", :action => "new"  
  map.login "/login", :controller => "user_sessions", :action => "new"
  map.logout "/logout", :controller => "user_sessions", :action => "destroy"  
  map.root :controller => "site", :action => 'index'
end
