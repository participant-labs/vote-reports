require File.dirname(__FILE__) + '/../../spec_helper'
 
describe Users::ReportsController do
  before do
    login
  end

  describe "routes" do
    route_matches("/reports/empact", :get,   :controller => 'users/reports', :action => 'index', :user_id => 'empact')
    route_matches("/reports/empact", :post,   :controller => 'users/reports', :action => 'create', :user_id => 'empact')
    route_matches("/reports/empact/new", :get,   :controller => 'users/reports', :action => 'new', :user_id => 'empact')
    route_matches("/reports/empact/my-report", :get,   :controller => 'users/reports', :action => 'show', :user_id => 'empact', :id => 'my-report')
    route_matches("/reports/empact/my-report", :delete,   :controller => 'users/reports', :action => 'destroy', :user_id => 'empact', :id => 'my-report')
    route_matches("/reports/empact/my-report", :put,   :controller => 'users/reports', :action => 'update', :user_id => 'empact', :id => 'my-report')
    route_matches("/reports/empact/my-report/edit", :get,   :controller => 'users/reports', :action => 'edit', :user_id => 'empact', :id => 'my-report')
  end

  describe "GET show" do
    context "when there is a better id for this report" do
      before do
        @report = create_report(:user => current_user)
        mock.instance_of(Report).has_better_id? { true }
      end

      it "should redirect" do
        get :show, :user_id => current_user, :id => @report
        response.should redirect_to(user_report_path(current_user, @report))
      end
    end
  end

  describe "GET edit" do
    before do
      @report = create_report(:user => current_user)
    end

    context "when there is a better id for this report" do
      before do
        mock.instance_of(Report).has_better_id? { true }
      end

      it "should redirect" do
        get :edit, :user_id => current_user, :id => @report
        response.should redirect_to(edit_user_report_path(current_user, @report))
      end
    end

    context "when I am not logged in" do
      it "should deny access" do
        logout
        get :edit, :user_id => @report.user, :id => @report
        response.should redirect_to(login_path(:return_to => edit_user_report_path(@report.user, @report)))
      end
    end

    context "when I am not the owner" do
      before do
        login(create_user)
        current_user.should_not == @report.user
      end

      it "should deny access" do
        get :edit, :user_id => @report.user, :id => @report
        response.should redirect_to(user_report_path(@report.user, @report))
      end
    end
  end

end
