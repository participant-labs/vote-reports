require 'spec_helper'

describe DistrictZipCode do
  before(:each) do
    @valid_attributes = {
      :district_id => 1,
      :zip_code => 1,
      :plus_4 => 1
    }
  end

  it "should create a new instance given valid attributes" do
    DistrictZipCode.create!(@valid_attributes)
  end
end
