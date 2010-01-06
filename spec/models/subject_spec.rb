require 'spec_helper'

describe Subject do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Subject.create!(@valid_attributes)
  end
end
