require File.dirname(__FILE__) + '/../spec_helper'

describe UserSessionsController do
  setup :activate_authlogic

  describe 'GET new' do
    it "routes from /login" do
      expect(get: '/login').to route_to(controller: 'user_sessions', action: 'new')
    end
  end

  describe 'POST create' do
    shared_examples_for 'failed sign-in' do
      it "tells me I'm wrong" do
        send_request
        expect(flash[:error]).to eq("Failed to login or register.")
      end
    end
    shared_examples_for 'successful sign-in' do
      it "tells me it worked" do
        send_request
        expect(flash[:notice]).to eq("Logged in successfully")
      end

      it "sends me to my dashboard" do
        send_request
        expect(response).to redirect_to(user_path(user))
      end

      context 'when I have a return path set' do
        it 'sends me to the return path' do
          send_request(return_to: causes_path)
          expect(response).to redirect_to(causes_path)
        end
      end
    end

    def send_request(args = {})
      post :create, args.merge(user_session: session_params)
    end

    context 'I am not signed up' do
      let(:session_params) {
        {username: 'email@person.com', password: 'password'}
      }
      it_behaves_like 'failed sign-in'
    end
    context "I'm signed up" do
      let(:user) { create(:user, password: 'password') }

      context "but I put in the wrong email" do
        let(:session_params) {
          {username: 'wrongemail@example.com', password: 'password'}
        }
        it_behaves_like 'failed sign-in'
      end

      context "but I put in the wrong password" do
        let(:session_params) {
          {username: user.email, password: 'wrongpassword'}
        }
        it_behaves_like 'failed sign-in'
      end

      context 'and I sign in by email' do
        let(:session_params) {
          {username: user.email, password: 'password'}
        }
        it_behaves_like 'successful sign-in'
      end
      context 'and I sign in by username' do
        let(:session_params) {
          {username: user.username, password: 'password'}
        }
        it_behaves_like 'successful sign-in'
      end
    end
  end

  describe 'DELETE destroy' do
    it "routes from /logout" do
      expect(get: '/logout').to route_to(controller: 'user_sessions', action: 'destroy')
    end

    context 'when logged in' do
      before { login }

      it 'alerts me to signout' do
        delete :destroy
        expect(flash[:notice]).to eq("You have been logged out")
      end

      it 'signs me out' do
        expect {
          delete :destroy
        }.to change(UserSession, :find).to(nil)
      end

      it 'sends me to the home page' do
        delete :destroy
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
