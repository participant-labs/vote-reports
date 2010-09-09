require 'spec_helper'

describe ReportScore do
  before(:each) do
    @valid_attributes = {
      :politician_id => 1,
      :report_id => 1,
      :score => 1.5
    }
  end

  it "should create a new instance given valid attributes" do
    ReportScore.create!(@valid_attributes)
  end

  describe "on destroy" do
    before do
      @score_evidence = create_report_score_evidence
      @score = @score_evidence.score
      @dependent_score_evidence = create_report_score_evidence(:evidence => @score)
      @dependent_score = @dependent_score_evidence.score
    end

    it "should destroy the score evidence" do
      @score.destroy
      ReportScoreEvidence.all.should_not include(@score_evidence)
    end

    it "should destroy dependent scores" do
      @score.destroy
      ReportScore.all.should_not include(@dependent_score)
    end

    it "should destroy dependent scores' evidence" do
      @score.destroy
      ReportScoreEvidence.all.should_not include(@dependent_score_evidence)
    end

    it "should rescore dependent scores' reports" do
      new_instance_of(Report) do |r|
        mock(r).rescore!
      end
      @score.destroy
    end
  end

end
