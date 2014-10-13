require 'rails_helper'

RSpec.describe Users::Reports::BillCriteriaController do
  setup :activate_authlogic

  describe "GET new" do
    before do
      login
      @report = create(:report, user: current_user)
    end

    context "when I am not logged in" do
      it "should deny access" do
        logout
        get :new, user_id: @report.user, report_id: @report, term: 'searchy!'
        expect(response).to redirect_to(login_path(return_to: new_user_report_bill_criterion_path(@report.user, @report)))
      end
    end

    context "when I am not the owner" do
      before do
        login(create(:user))
        expect(current_user).to_not eq(@report.user)
      end

      it "should deny access" do
        get :new, user_id: @report.user, report_id: @report, term: 'searchy!'
        expect(response).to redirect_to(user_report_path(@report.user, @report))
      end
    end
  end

end
