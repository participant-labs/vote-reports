ActionController::Routing::Routes.draw do |map|

  map.resources :rolls, :only => [:show]
  map.resources :bills, :only => [:index, :show]
  map.resources :politicians, :only => [:index, :show]
  map.resources :subjects, :only => [:index, :show]
  map.resources :interest_groups, :only => [:index, :show]

  map.resources :reports, :only => [:index, :new]
  map.resource :location
  map.resource :guide

  map.resources :us_states, :as => 'us/states', :controller => 'us/states', :only => 'show'
  map.resources :districts, :as => 'us/congressional_districts', :controller => 'us/districts', :only => 'show'

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
    :controller => 'users/reports', :action => 'edit', :conditions =>  { :method => :get }
  map.edit_user_report_thumbnail  "reports/:user_id/:report_id/thumbnail/edit",
    :controller => 'users/reports/thumbnails', :action => 'edit', :conditions => { :method => :get }

  map.new_user_report_bills "reports/:user_id/:report_id/bills/new",
    :controller => 'users/reports/bills', :action => 'new', :conditions => { :method => :get }
  map.edit_user_report_bills "reports/:user_id/:report_id/bills/edit",
    :controller => 'users/reports/bills', :action => 'edit', :conditions => { :method => :get }
  map.user_report_bill "reports/:user_id/:report_id/bills/:id",
    :controller => 'users/reports/bills', :action => 'destroy', :conditions => { :method => :delete }

  map.about "about", :controller => "site", :action => "show"  

  map.resources :user_sessions
  map.resources :users do |user|
    user.resources :rpx_identities, :only => [:create, :destroy], :controller => 'users/rpx_identities'
  end

  map.signup "/signup", :controller => "users", :action => "new"  
  map.login "/login", :controller => "user_sessions", :action => "new"
  map.logout "/logout", :controller => "user_sessions", :action => "destroy"  

  Jammit::Routes.draw(map)

  map.root :controller => "site", :action => 'index'
end
