require 'spec_helper'

describe ZipCode do
  before(:each) do
    @valid_attributes = {
      :zip_code => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ZipCode.create!(@valid_attributes)
  end
end
