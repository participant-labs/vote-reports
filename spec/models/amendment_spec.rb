require 'spec_helper'

describe Amendment do
  before(:each) do
    @valid_attributes = {
      :bill_id => 1,
      :gov_track_id => "value for gov_track_id"
    }
  end

  it "should create a new instance given valid attributes" do
    Amendment.create!(@valid_attributes)
  end
end
