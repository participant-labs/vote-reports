ActionController::Routing::Routes.draw do |map|

  map.resources :rolls, :only => [:show]
  map.resources :bills, :only => [:index, :show]
  map.resources :politicians, :only => [:index, :show]
  map.resources :subjects, :only => [:index, :show]
  map.resources :interest_groups, :only => [:index, :show]

  map.resources :reports, :only => [:index, :new] do |report|
    report.resources :scores, :controller => 'reports/scores', :only => :show
  end
  map.resource :location
  map.resource :guide

  map.resources :us_states, :as => 'us/states', :controller => 'us/states', :only => 'show' do |state|
    state.resource :map, :controller => 'us/states/maps', :only => 'show'
  end
  map.resources :districts, :as => 'us/congressional_districts', :controller => 'us/districts', :only => 'show' do |district|
    district.resource :map, :controller => 'us/districts/maps', :only => 'show'
  end

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
  map.user_report_image  "reports/:user_id/:report_id/thumbnail",
    :controller => 'users/reports/thumbnails', :action => 'update', :conditions => { :method => :put }

  map.user_report_bill_criteria "reports/:user_id/:report_id/bill_criteria",
    :controller => 'users/reports/bill_criteria', :action => 'index', :conditions => { :method => :get }
  map.new_user_report_bill_criteria "reports/:user_id/:report_id/bill_criteria/new",
    :controller => 'users/reports/bill_criteria', :action => 'new', :conditions => { :method => :get }
  map.user_report_bill_criterion "reports/:user_id/:report_id/bill_criteria/:id",
    :controller => 'users/reports/bill_criteria', :action => 'destroy', :conditions => { :method => :delete }

  map.about "about", :controller => "site", :action => "show"  

  map.resources :user_sessions
  map.resources :users do |user|
    user.resources :rpx_identities, :only => [:create, :destroy], :controller => 'users/rpx_identities'
    user.resource :adminship, :only => [:create, :destroy], :controller => 'users/adminships'
  end

  map.signup "/signup", :controller => "users", :action => "new"  
  map.login "/login", :controller => "user_sessions", :action => "new"
  map.logout "/logout", :controller => "user_sessions", :action => "destroy"  

  Jammit::Routes.draw(map)

  map.root :controller => "site", :action => 'index'
end
