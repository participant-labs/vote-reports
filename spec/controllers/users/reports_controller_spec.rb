require File.dirname(__FILE__) + '/../../spec_helper'
 
describe Users::ReportsController do

  describe "routes" do
    route_matches("/reports/empact", :get,   :controller => 'users/reports', :action => 'index', :user_id => 'empact')
    route_matches("/reports/empact", :post,   :controller => 'users/reports', :action => 'create', :user_id => 'empact')
    route_matches("/reports/empact/new", :get,   :controller => 'users/reports', :action => 'new', :user_id => 'empact')
    route_matches("/reports/empact/my-report", :get,   :controller => 'users/reports', :action => 'show', :user_id => 'empact', :id => 'my-report')
    route_matches("/reports/empact/my-report", :delete,   :controller => 'users/reports', :action => 'destroy', :user_id => 'empact', :id => 'my-report')
    route_matches("/reports/empact/my-report", :put,   :controller => 'users/reports', :action => 'update', :user_id => 'empact', :id => 'my-report')
    route_matches("/reports/empact/my-report/edit", :get,   :controller => 'users/reports', :action => 'edit', :user_id => 'empact', :id => 'my-report')
  end

end
