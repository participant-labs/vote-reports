require 'spec_helper'

describe ReportSubject do
  before(:each) do
    @valid_attributes = {
      :report_id => 1,
      :subject_id => 1,
      :count => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ReportSubject.create!(@valid_attributes)
  end
end
