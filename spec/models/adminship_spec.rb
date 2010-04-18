require 'spec_helper'

describe Adminship do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :created_by_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Adminship.create!(@valid_attributes)
  end
end
