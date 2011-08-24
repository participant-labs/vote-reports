require 'spec_helper'

describe BillsController do
  setup :activate_authlogic

  describe "routes" do
    route_matches("/bills",   :get,   :controller => 'bills', :action => 'index')
    route_matches("/bills/1", :get,   :controller => 'bills', :action => 'show', :id => '1')
    it "should not support nested crud" do
      {:post=>"/bills"}.should_not be_routable
      {:put => "/bills/1"     }.should_not be_routable
      {:delete => "/bills/1"  }.should_not be_routable
      {:get => "/bills/1/edit"}.should_not be_routable
    end
  end

end
