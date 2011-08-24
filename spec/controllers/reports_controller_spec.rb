require File.dirname(__FILE__) + '/../spec_helper'
 
describe ReportsController do
  setup :activate_authlogic

  requires_login_for :get,    :new

  describe "routes" do
    route_matches("/reports",        :get,   :controller => 'reports', :action => 'index')
    route_matches("/reports/new",    :get,   :controller => 'reports', :action => 'new')    
  end

end
