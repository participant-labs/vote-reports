require 'spec_helper'

describe CommitteeMembership do
  before(:each) do
    @valid_attributes = {
      :congress_id => 1,
      :politician_id => 1,
      :committee_id => 1,
      :role => "value for role"
    }
  end

  it "should create a new instance given valid attributes" do
    CommitteeMembership.create!(@valid_attributes)
  end
end
