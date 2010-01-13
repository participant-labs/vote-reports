require File.dirname(__FILE__) + '/../spec_helper'

describe Report do
  describe "creation" do
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

  describe ".published" do
    it "should return reports with bill_criteria" do
      create_report
      published_report = create_report
      create_bill_criterion(:report => published_report)

      Report.published.should == [published_report]
    end
  end

  describe ".scored" do
    it "should return reports with voted bill_criteria" do
      create_report
      published_report = create_report
      create_bill_criterion(:report => published_report)
      scored_report = create_report
      bill = create_bill
      create_bill_criterion(:report => scored_report, :bill => bill)
      create_roll(:subject => bill)

      Report.scored.should == [scored_report]
    end
  end
end
