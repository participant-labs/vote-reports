require File.dirname(__FILE__) + '/../spec_helper'
 
describe ReportsController do

  requires_login_for :get,    :new

  describe "routes" do
    route_matches("/reports",        :get,   :controller => 'reports', :action => 'index')
    route_matches("/reports/new",    :get,   :controller => 'reports', :action => 'new')    
    it "should not support nested crud" do
      {:post=>"/reports"}.should_not be_routable
      {:get => "/reports/1"     }.should_not be_routable
      {:put => "/reports/1"     }.should_not be_routable
      {:delete => "/reports/1"  }.should_not be_routable
      {:get => "/reports/1/edit"}.should_not be_routable
    end
  end

end
