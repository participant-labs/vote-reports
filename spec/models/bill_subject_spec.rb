require 'spec_helper'

describe BillSubject do
  before(:each) do
    @valid_attributes = {
      :bill_id => 1,
      :term_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    BillSubject.create!(@valid_attributes)
  end
end
