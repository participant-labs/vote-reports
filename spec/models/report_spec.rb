require File.dirname(__FILE__) + '/../spec_helper'

describe Report do
  describe "creation" do
    it "should be validate presence of name" do
      lambda do
        @report = Report.new(name: nil)
        @report.save
      end.should_not change(Report,:count)
      @report.errors[:name].should include("can't be blank")
    end
  end

  describe "destruction" do
    it "should delete related criteria" do
      report = create(:report, :published)
      criteria = report.bill_criteria
      criteria.should_not be_empty
      lambda {
        report.destroy
      }.should change(BillCriterion, :count).by(-criteria.count)
    end
  end

  describe ".with_criteria" do
    it "should return reports with bill_criteria" do
      create(:report)
      published_report = create(:report)
      create(:bill_criterion, report: published_report)

      Report.with_criteria.should == [published_report]
    end
  end

  describe ".unpublished" do
    it  "should include private and unlisted reports" do
      unlisted = create(:report, :unlisted)
      private_report = create(:report)
      Report.unpublished.to_a.should =~ [unlisted, private_report]
    end

    it "should not include personal reports" do
      personal = create(:report, :personal)
      Report.unpublished.should_not include(personal)
    end

    it "should not include published reports" do
      published = create(:report, :published)
      published.state.should == 'published'
      Report.unpublished.should_not include(published)
    end
  end

  describe ".scored" do
    before do
      create(:report)
      published_report = create(:report)
      create(:bill_criterion, report: published_report)
      @report = create(:report)
      @bill = create(:bill)
      create(:bill_criterion, report: @report, bill: @bill)
    end

    it "should not return reports with non-passage votes" do
      roll = create(:roll, subject: @bill)
      Bill::ROLL_PASSAGE_TYPES.should_not include(roll.roll_type)

      Report.scored.should == []
    end

    it "should return reports with voted bill_criteria" do
      create(:roll, subject: @bill, roll_type: Bill::ROLL_PASSAGE_TYPES.sample)

      Report.scored.should == [@report]
    end
  end

  describe "#rescore!" do
    before do
      @report = create(:report)
    end

    it "should not create a delayed job accessible via #delayed_jobs" do
      lambda {
        @report.rescore!
      }.should_not change(@report.delayed_jobs, :count)
    end

    context "when the report has a score criteria" do
      before do
        create(:bill_criterion, report: @report)
        roll = create(:roll, subject: @report.reload.bill_criteria.first.bill, roll_type: "On Passage")
      end

      it "should create a delayed job accessible via #delayed_jobs" do
        lambda {
          @report.rescore!
        }.should change(@report.delayed_jobs, :count).by(1)
      end

      context "when a rescore is active" do
        before do
          Delayed::Worker.new(quiet: true).work_off(10)
          @report.rescore!
        end

        it "completing the rescore should remove it from the active jobs" do
          lambda {
            Delayed::Worker.new(quiet: true).work_off(1)
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
end
