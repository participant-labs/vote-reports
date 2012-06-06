require 'spec_helper'

describe SiteController do
  describe 'GET index' do
    context "when I'm signed in" do
      setup :activate_authlogic

      before { login }

      it 'send me to my dashboard' do
        get :index
        response.should redirect_to(user_path(current_user))
      end
    end
    it 'succeeds' do
      get :index
      response.should be_success
    end
  end
end
