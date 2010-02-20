require File.dirname(__FILE__) + '/../spec_helper'

describe User do
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
    @user.errors.on(:username).should include("has already been taken")
  end

  describe "merging" do
    before do
      @from_user = create_user
      @to_user = create_user
      @from_report = create_published_report(:user => @from_user)
      @to_report = create_published_report(:user => @to_user)
    end

    it "should transfer reports" do
      @from_user.send(:before_merge_rpx_data, @from_user, @to_user)
      @to_user.reports(true).should =~ [@from_report, @to_report]
      @from_user.reports(true).should be_empty
    end

    it "should generate new slugs for reports" do
      lambda {
        @from_user.send(:before_merge_rpx_data, @from_user, @to_user)
      }.should change(Slug, :count).by(@from_user.reports.count)
    end

    it "should transfer slugs" do
      @from_user.to_param.should_not == @to_user.to_param
      @from_user.send(:before_merge_rpx_data, @from_user, @to_user)
      report = Report.find(@from_report.to_param, :scope => @from_user.to_param)
      Report.find(@from_report.to_param, :scope => @to_user.to_param).should_not 
      report.user.should == @to_user
      report.should be_has_better_id
    end

    it "should disable the account" do
      @from_user.should be_active
      @from_user.send(:after_merge_rpx_data, @from_user, @to_user)
      @from_user.should be_disabled
    end
  end
end
