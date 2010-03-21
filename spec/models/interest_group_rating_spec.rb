require 'spec_helper'

describe InterestGroupRating do
  before(:each) do
    @valid_attributes = {
      :interest_group_id => 1,
      :vote_smart_id => "value for vote_smart_id",
      :rating => "value for rating",
      :description => "value for description",
      :time_span => "value for time_span"
    }
  end

  it "should create a new instance given valid attributes" do
    InterestGroupRating.create!(@valid_attributes)
  end
end
