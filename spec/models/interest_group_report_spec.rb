require 'spec_helper'

describe InterestGroupReport do
  before(:each) do
    @valid_attributes = {
      :interest_group_id => 1,
      :timespan => "value for timespan",
      :vote_smart_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    InterestGroupReport.create!(@valid_attributes)
  end
end
