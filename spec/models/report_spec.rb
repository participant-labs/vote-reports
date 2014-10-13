require 'rails_helper'

RSpec.describe Report do
  describe "creation" do
    it "should be validate presence of name" do
      expect do
        @report = Report.new(name: nil)
        @report.save
      end.to_not change(Report,:count)
      expect(@report.errors[:name]).to include("can't be blank")
    end
  end

  describe "destruction" do
    it "should delete related criteria" do
      report = create(:report, :published)
      criteria = report.bill_criteria
      expect(criteria).to_not be_empty
      expect {
        report.destroy
      }.to change(BillCriterion, :count).by(-criteria.count)
    end
  end

  describe ".with_criteria" do
    it "should return reports with bill_criteria" do
      create(:report)
      published_report = create(:report)
      create(:bill_criterion, report: published_report)

      expect(Report.with_criteria).to eq([published_report])
    end
  end

  describe ".unpublished" do
    it  "should include private and unlisted reports" do
      unlisted = create(:report, :unlisted)
      private_report = create(:report)
      expect(Report.unpublished.to_a).to match_array([unlisted, private_report])
    end

    it "should not include personal reports" do
      personal = create(:report, :personal)
      expect(Report.unpublished).to_not include(personal)
    end

    it "should not include published reports" do
      published = create(:report, :published)
      expect(published.state).to eq('published')
      expect(Report.unpublished).to_not include(published)
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
      expect(Bill::ROLL_PASSAGE_TYPES).to_not include(roll.roll_type)

      expect(Report.scored).to eq([])
    end

    it "should return reports with voted bill_criteria" do
      create(:roll, subject: @bill, roll_type: Bill::ROLL_PASSAGE_TYPES.sample)

      expect(Report.scored).to eq([@report])
    end
  end

  describe "#rescore!" do
    before do
      @report = create(:report)
    end

    it "should not create a delayed job accessible via #delayed_jobs" do
      expect {
        @report.rescore!
      }.to_not change(@report.delayed_jobs, :count)
    end

    context "when the report has a score criteria" do
      before do
        create(:bill_criterion, report: @report)
        roll = create(:roll, subject: @report.reload.bill_criteria.first.bill, roll_type: "On Passage")
      end

      it "should create a delayed job accessible via #delayed_jobs" do
        expect {
          @report.rescore!
        }.to change(@report.delayed_jobs, :count).by(1)
      end

      context "when a rescore is active" do
        before do
          Delayed::Worker.new(quiet: true).work_off(10)
          @report.rescore!
        end

        it "completing the rescore should remove it from the active jobs" do
          expect {
            Delayed::Worker.new(quiet: true).work_off(1)
          }.to change(@report.delayed_jobs, :count).by(-1)
        end

        it "should not create duplicate jobs for the pending action" do
          expect {
            @report.rescore!
          }.to_not change(@report.delayed_jobs, :count)
        end
      end
    end
  end
end
