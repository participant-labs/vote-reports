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

  describe ".with_criteria" do
    it "should return reports with bill_criteria" do
      create_report
      published_report = create_report
      create_bill_criterion(:report => published_report)

      Report.with_criteria.should == [published_report]
    end
  end

  describe ".scored" do
    before do
      create_report
      published_report = create_report
      create_bill_criterion(:report => published_report)
      @report = create_report
      @bill = create_bill
      create_bill_criterion(:report => @report, :bill => @bill)
    end

    it "should not return reports with non-passage votes" do
      roll = create_roll(:subject => @bill)
      Roll::PASSAGE_TYPES.should_not include(roll.roll_type)

      Report.scored.should == []
    end

    it "should return reports with voted bill_criteria" do
      create_roll(:subject => @bill, :roll_type => Roll::PASSAGE_TYPES.rand)

      Report.scored.should == [@report]
    end
  end
end
