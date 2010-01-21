require 'spec_helper'

describe ReportScoreEvidence do
  before(:each) do
    @valid_attributes = {
      :report_score_id => 1,
      :roll_id => 1,
      :bill_criterion_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ReportScoreEvidence.create!(@valid_attributes)
  end
end
