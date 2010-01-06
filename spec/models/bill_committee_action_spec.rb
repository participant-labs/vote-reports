require 'spec_helper'

describe BillCommitteeAction do
  before(:each) do
    @valid_attributes = {
      :action => "value for action",
      :committee_id => 1,
      :bill_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    BillCommitteeAction.create!(@valid_attributes)
  end
end
