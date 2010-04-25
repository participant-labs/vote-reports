require 'spec_helper'

describe Moderatorship do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :created_by_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Moderatorship.create!(@valid_attributes)
  end
end
