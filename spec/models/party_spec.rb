require 'rails_helper'

RSpec.describe Party do
  before(:each) do
    @valid_attributes = {
      name: "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    Party.create!(@valid_attributes)
  end
end
