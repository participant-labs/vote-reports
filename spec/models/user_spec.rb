require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it "should be created with valid attributes" do
    lambda do
      Factory(:user)
    end.should change(User,:count).by(1)
  end
  
  it "should validate uniqueness of username" do
    user = Factory.create(:user, :username => 'foo')
    lambda do
      @user = Factory.build(:user, :username => 'foo')
      @user.save
    end.should_not change(User,:count)
    @user.errors.on(:username).should include("has already been taken")
  end
end
