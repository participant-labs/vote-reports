require File.dirname(__FILE__) + '/../spec_helper'

describe UserSessionsController do
  setup :activate_authlogic

  describe "route recognition" do
    it "should route the login route correctly" do
      {get: '/login'}.should route_to(controller: 'user_sessions', action: 'new')
    end
  end

  describe 'DELETE destroy' do
    it "routes from /logout" do
      {get: '/logout'}.should route_to(controller: 'user_sessions', action: 'destroy')
    end

    context 'when logged in' do
      before { login }

      it 'alerts me to signout' do
        delete :destroy
        flash[:notice].should == "You have been logged out"
      end

      it 'signs me out' do
        expect {
          delete :destroy
        }.to change(UserSession, :find).to(nil)
      end

      it 'sends me to the home page' do
        delete :destroy
        response.should redirect_to(root_path)
      end
    end
  end
end
