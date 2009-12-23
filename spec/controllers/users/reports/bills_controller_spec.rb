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

  describe "GET new" do
    context "when there is a better id for this report" do
      before do
        login
        @report = Factory.create(:report, :user => current_user)
        mock(@report).has_better_id? { true }
      end

      it "should redirect" do
        get :new, :user_id => current_user, :report_id => @report, :q => 'Smelly Roses'
        response.should_be redirect_to(new_user_report_bills_path(current_user, @report))
      end
    end
  end

end
