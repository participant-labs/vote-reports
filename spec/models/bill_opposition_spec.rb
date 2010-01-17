require 'spec_helper'

describe BillOpposition do
  before(:each) do
    @valid_attributes = {
      :politician_id => 1,
      :bill_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    BillOpposition.create!(@valid_attributes)
  end
end
