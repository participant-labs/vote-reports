require File.dirname(__FILE__) + '/../spec_helper'

describe Report, "creation" do
  it "should be validate presence of name" do
    lambda do
      @report = Report.new(:name => nil)
      @report.save
    end.should_not change(Report,:count)
    @report.errors.on(:name).should include("can't be blank")
  end
  
  it "should be validate presence of user_id" do
    lambda do
      @report = Report.new(:user_id => nil)
      @report.save
    end.should_not change(Report,:count)
    @report.errors.on(:user).should include("can't be blank")
  end
end
