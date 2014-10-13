require 'rails_helper'

RSpec.describe Users::ReportsController do
  setup :activate_authlogic

  before do
    login
  end

  describe "GET show" do
    context "when there is a better id for this report" do
      before do
        @report = create(:report, user: current_user)
      end

      it "should redirect" do
        expect(@report.to_param).to_not eq(@report.id.to_s)
        get :show, user_id: current_user, id: @report.id
        expect(response).to redirect_to(user_report_path(current_user, @report))
      end
    end
  end

  describe "GET edit" do
    before do
      @report = create(:report, user: current_user)
    end

    context "when there is a better id for this report" do
      it "should redirect" do
        get :edit, user_id: current_user, id: @report.id
        expect(response).to redirect_to(edit_user_report_path(current_user, @report))
      end
    end

    context "when I am not logged in" do
      it "should deny access" do
        logout
        get :edit, user_id: @report.user, id: @report
        expect(response).to redirect_to(login_path(return_to: edit_user_report_path(@report.user, @report)))
      end
    end

    context "when I am not the owner" do
      before do
        login(create(:user))
        expect(current_user).to_not eq(@report.user)
      end

      context "and you have permission to see the report" do
        it "should deny access" do
          @report.share!
          get :edit, user_id: @report.user, id: @report
          expect(response).to redirect_to(user_report_url(@report.user, @report))
        end
      end

      context "and the report is private" do
        it "should deny access and send me to the user report page" do
          get :edit, user_id: @report.user, id: @report
          expect(response).to redirect_to(user_reports_url(@report.user))
        end
      end
    end
  end

end
