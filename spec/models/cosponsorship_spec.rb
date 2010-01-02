require 'spec_helper'

describe Cosponsorship do
  before(:each) do
    @valid_attributes = {
      :bill_id => 1,
      :politician_id => 1,
      :joined_on => Date.today
    }
  end

  it "should create a new instance given valid attributes" do
    Cosponsorship.create!(@valid_attributes)
  end
end
