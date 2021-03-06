require 'rails_helper'

RSpec.describe Users::RpxIdentitiesController do
  setup :activate_authlogic

  describe "POST #create" do
    describe "on adding a registration to an existing user" do
      def send_request(user)
        allow(UserSession).to receive(:find).and_return(UserSession.create(user))
        post :create, user_id: user.to_param,
          "token"=>"2a6e5bb00cd01b94752c26e55bbde78242e1514b",
          "authenticity_token"=>"WJhfd6WXN6DG9ujdhK9YG8pFK5GSPZJfRE43EedI+EQ=",
          "add_rpx"=>"true",
          "profile" => {
            "verifiedEmail" => "ben.woosley@gmail.com",
            "name" => {
              "givenName" => "Ben",
              "familyName" => "Woosley",
              "formatted" => "Ben Woosley"
            },
            "displayName" => "ben.woosley",
            "preferredUsername" => "ben.woosley",
            "providerName" => "Google",
            "identifier" => @identifier,
            "email" => "ben.woosley@gmail.com"
          },
          "stat" => "ok"
      end

      context 'as a user' do
        let(:user) { create(:user) }
        before { login user }

        context "when adding to someone else" do
          let(:modified)  { create(:user) }

          it "should redirect" do
            send_request(modified)
            expect(response).to redirect_to(user_path(modified))
          end

          it "should not create an rpx identity" do
            expect {
              send_request(modified)
            }.to_not change(RPXIdentifier, :count)
          end
        end

        context "when I'm adding to myself" do
          before do
            @identifier = "https://www.google.com/accounts/o8/id?id=AItOawk9vs1fKTQ-PEoono_hovx95Nt5qWG6LUk"
          end

          it "should redirect to user page" do
            send_request(user)
            expect(response).to redirect_to(user_path(user))
          end

          it "should notify of success" do
            send_request(user)
            expect(flash[:notice]).to eq("Successfully added login to this account.")
          end
        end
      end
    end
  end
end
