require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  setup :activate_authlogic

  describe "route recognition" do
    it "should route the signup route correctly" do
      expect(get: '/signup').to route_to(controller: 'users', action: 'new')
    end
  end

  describe "GET index" do
    it "should reject me if I'm not logged in" do
      get :index
      expect(flash[:notice]).to eq("You must be logged in to access this page")
      expect(response).to redirect_to(login_url(return_to: '/users'))
    end

    it "should reject me if I'm not an admin" do
      login
      get :index
      expect(flash[:error]).to eq("You may not access this page")
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET show" do
    let(:other_user) { create(:user) }

    context 'when logged in' do
      before do
        login
      end

      context 'viewing a different user' do
        it 'sends me their reports page' do
          get :show, id: other_user
          expect(response).to redirect_to(user_reports_path(other_user))
        end
      end

      context 'viewing my own page' do
        it 'succeeds' do
          get :show, id: current_user
          expect(response).to be_success
        end
      end
    end
  end

  describe "GET edit" do
    before do
      @user = create(:user)
    end

    it "should reject me if I'm not logged in" do
      logout
      get :edit, id: @user
      expect(response).to redirect_to(login_url(return_to: %Q{/users/#{@user.to_param}/edit}))
      expect(flash[:notice]).to eq("You must be logged in to access this page")
    end

    it "should reject me if I'm not the user being edited" do
      current = create(:user)
      login(current)
      get :edit, id: @user
      expect(response).to redirect_to(user_reports_url(@user))
      expect(flash[:error]).to eq("You may not access this page")
    end
  end
end
