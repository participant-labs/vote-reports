require 'spec_helper'

describe ReportFollow do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :report_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ReportFollow.create!(@valid_attributes)
  end
end
