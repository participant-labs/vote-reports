require 'spec_helper'

describe LocationZipCode do
  before(:each) do
    @valid_attributes = {
      :zip_code => 1,
      :lat => 1.5,
      :lng => 1.5,
      :city => "value for city",
      :state => "value for state",
      :county => "value for county",
      :zip_code_type => "value for zip_code_type",
      :primary => "value for primary",
      :country => "value for country",
      :location_id => "value for location_id",
      :location_name => "value for location_name",
      :population => "value for population",
      :housing_units => "value for housing_units",
      :income => "value for income",
      :land_area => "value for land_area",
      :water_area => "value for water_area",
      :decommissioned => "value for decommissioned",
      :military_restriction_codes => "value for military_restriction_codes"
    }
  end

  it "should create a new instance given valid attributes" do
    LocationZipCode.create!(@valid_attributes)
  end
end
