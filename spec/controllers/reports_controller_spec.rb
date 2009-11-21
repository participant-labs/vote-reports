require File.dirname(__FILE__) + '/../spec_helper'
 
describe ReportsController do

  requires_login_for :post,   :create  
  requires_login_for :put,    :update  
  requires_login_for :get,    :edit
  requires_login_for :get,    :new
  requires_login_for :delete, :destroy
  
  describe "routes" do
    route_matches("/reports",        :get,   :controller => 'reports', :action => 'index')
    route_matches("/reports/new",    :get,   :controller => 'reports', :action => 'new')    
    route_matches("/reports",        :post,  :controller => 'reports', :action => 'create')    
    route_matches("/reports/1",      :get,   :controller => 'reports', :action => 'show',    :id => '1')
    route_matches("/reports/1/edit", :get,   :controller => 'reports', :action => 'edit',    :id => '1')
    route_matches("/reports/1",      :put,   :controller => 'reports', :action => 'update',  :id => '1')
    route_matches("/reports/1",      :delete,:controller => 'reports', :action => 'destroy', :id => '1')
  end
  
  describe "nested routes" do
    it "should description" do
      params_from(:get,    "/reports"       ).should == {:controller => 'reports', :action => 'index'}
      params_from(:get,    "/reports/new"   ).should == {:controller => 'reports', :action => 'new'}
      params_from(:post,   "/reports"       ).should == {:controller => 'reports', :action => 'create'}
      params_from(:get,    "/reports/1"     ).should == {:controller => 'reports', :action => 'show',    :id => '1'}
      params_from(:get,    "/reports/1/edit").should == {:controller => 'reports', :action => 'edit',    :id => '1'}
      params_from(:put,    "/reports/1"     ).should == {:controller => 'reports', :action => 'update',  :id => '1'}
      params_from(:delete, "/reports/1"     ).should == {:controller => 'reports', :action => 'destroy', :id => '1'}
    end                  

  end
  
end
