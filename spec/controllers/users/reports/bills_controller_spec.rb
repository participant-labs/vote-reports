require File.dirname(__FILE__) + '/../../../spec_helper'

describe Users::Reports::BillsController do

  describe "routes" do
    route_matches("/reports/empact/my-report/bills/new",   :get,   :controller => 'users/reports/bills', :action => 'new', :user_id=>"empact", :report_id=>"my-report")
    it "should not support nested crud" do
      {:get => "/reports/empact/my-report/bills/1"}.should_not be_routable
      {:post=>"/reports/empact/my-report/bills"}.should_not be_routable
      {:put => "/reports/empact/my-report/bills/1"     }.should_not be_routable
      {:delete => "/reports/empact/my-report/bills/1"  }.should_not be_routable
      {:get => "/reports/empact/my-report/bills/1/edit"}.should_not be_routable
    end
  end

end
