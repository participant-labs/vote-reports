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
end
