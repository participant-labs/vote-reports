require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before do
    @user = create_user
  end

  it "should be created with valid attributes" do
    lambda do
      create_user
    end.should change(User,:count).by(1)
  end

  it "should validate uniqueness of username" do
    user = create_user(:username => 'foo')
    lambda do
      @user = User.new(:username => 'foo')
      @user.save
    end.should_not change(User, :count)
    @user.errors[:username].should include("has already been taken")
  end

  describe "#reports" do
    it "should include private reports" do
      private_report = create_private_report(:user => @user)
      @user.reports.should include(private_report)
    end

    it "should include #personal_report" do
      personal = create_personal_report(:user => @user)
      @user.reports.should include(personal)
    end
  end

  describe "#personal_report" do
    it "should not misidentify a non-personal_report" do
      private_report = create_private_report(:user => @user)
      @user.personal_report.should_not == private_report
    end
  end
end
