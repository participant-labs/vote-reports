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

    it "should be validate presence of owner" do
      lambda do
        @report = Report.new(:user_id => nil)
        @report.save
      end.should_not change(Report,:count)
      @report.errors.on(:owner).should include("can't be blank")
      lambda do
        @report = Report.new(:interest_group_id => nil)
        @report.save
      end.should_not change(Report,:count)
      @report.errors.on(:owner).should include("can't be blank")

      @report = Report.new(:user => create_user)
      @report.save
      @report.errors.on(:owner).should be_blank
      @report = Report.new(:interest_group => create_interest_group)
      @report.save
      @report.errors.on(:owner).should be_blank
    end
  end

  describe "destruction" do
    it "should delete related criteria" do
      report = create_published_report
      criteria = report.bill_criteria
      criteria.should_not be_empty
      lambda {
        report.destroy
      }.should change(BillCriterion, :count).by(-criteria.count)
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

  describe "#rescore!" do
    before do
      @report = create_report
    end

    it "should create a delayed job accessible via #delayed_jobs" do
      lambda {
        @report.rescore!
      }.should change(@report.delayed_jobs, :count).by(1)
    end

    context "when a rescore is active" do
      before do
        @report.rescore!
      end

      it "completeing the rescore should remove it from the active jobs" do
        lambda {
          Delayed::Worker.new(:quiet => true).work_off(1)
        }.should change(@report.delayed_jobs, :count).by(-1)
      end

      it "should not create duplicate jobs for the pending action" do
        lambda {
          @report.rescore!
        }.should_not change(@report.delayed_jobs, :count)
      end
    end
  end
end
