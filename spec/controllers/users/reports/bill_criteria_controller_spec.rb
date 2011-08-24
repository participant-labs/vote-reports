require File.dirname(__FILE__) + '/../../../spec_helper'

describe Users::Reports::BillCriteriaController do
  setup :activate_authlogic

  describe "routes" do
    route_matches("/reports/empact/my-report/bill_criteria/new",   :get,   :controller => 'users/reports/bill_criteria', :action => 'new', :user_id=>"empact", :report_id=>"my-report")
    route_matches("/reports/empact/my-report/bill_criteria/1",   :delete,   :controller => 'users/reports/bill_criteria', :action => 'destroy', :user_id=>"empact", :report_id=>"my-report", :id => '1')
    it "should not support nested crud" do
      {:get => "/reports/empact/my-report/bill_criteria/1"}.should_not be_routable
      {:post=>"/reports/empact/my-report/bills"}.should_not be_routable
      {:put => "/reports/empact/my-report/bill_criteria/1"     }.should_not be_routable
      {:get => "/reports/empact/my-report/bill_criteria/1/edit"}.should_not be_routable
    end
  end

  describe "GET new" do
    before do
      login
      @report = create_report(:user => current_user)
    end

    context "when there is a better id for this report" do
      it "should redirect" do
        get :new, :user_id => current_user, :report_id => @report, :term => 'Smelly Roses'
        response.should redirect_to(new_user_report_bill_criterion_path(current_user, @report))
      end
    end

    context "when I am not logged in" do
      it "should deny access" do
        logout
        get :new, :user_id => @report.user, :report_id => @report, :term => 'searchy!'
        response.should redirect_to(login_path(:return_to => new_user_report_bill_criterion_path(@report.user, @report)))
      end
    end

    context "when I am not the owner" do
      before do
        login(create_user)
        current_user.should_not == @report.user
      end

      it "should deny access" do
        get :new, :user_id => @report.user, :report_id => @report, :term => 'searchy!'
        response.should redirect_to(user_report_path(@report.user, @report))
      end
    end
  end

end
