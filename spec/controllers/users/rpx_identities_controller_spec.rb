require File.dirname(__FILE__) + '/../../spec_helper'

describe Users::RpxIdentitiesController do
  setup :activate_authlogic

  describe "POST #create" do
    describe "on adding a registration to an existing user" do
      def create_post(user)
        post :create, :user_id => user.to_param,
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

      context "when someone else is attempting to add" do
        before do
          @current = create_user
          login(@current)
          @modified = create_user
          create_post(@modified)
        end

        it "should redirect" do
          response.should redirect_to(user_path(@modified))
        end

        it "should not create an rpx identity" do
          RPXIdentifier.find_by_identifier(@identifier).should == nil
          User.find_by_rpx_identifier(@identifier).should == nil
        end
      end

      context "when I'm adding to myself" do
        before do
          @current = create_user
          login(@current)
          @identifier = "https://www.google.com/accounts/o8/id?id=AItOawk9vs1fKTQ-PEoono_hovx95Nt5qWG6LUk"
        end

        it "should redirect to user page" do
          create_post(@current)
          response.should redirect_to(user_path(@current))
        end

        it "should notify of success" do
          create_post(@current)
          flash[:notice].should == "Successfully added login to this account."
        end

        it "should create an RPXIdentifier" do
          pending "Tokens are time-sensitive and I don't know how to generate them properly"
          lambda {
            create_post(@current)
          }.should change(RPXIdentifier, :count).by(1)
        end

        it "should create an rpx_identifier record" do
          pending "Tokens are time-sensitive and I don't know how to generate them properly"
          create_post(@current)
          RPXIdentifier.find_by_identifier(@identifier).user.should == @current
          User.find_by_rpx_identifier(@identifier).should == @current
        end
      end
    end
  end
end
