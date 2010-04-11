require 'spec_helper'

describe District do
  describe ".for_city" do
    before do
      @nm_district = create_district
      @ca_district = create_district
      @nm_district.zip_codes << create_zip_code(:zip_code => '11111')
      @ca_district.zip_codes << create_zip_code(:zip_code => '22222')
      create_location(:city => 'SAN FRANCISCO', :state => 'CA', :zip_code => '22222')
      create_location(:city => 'SAN FRANCISCO', :state => 'NM', :zip_code => '11111')
    end

    it "should handle cities alone" do
      District.for_city('san francisco').should =~ [@nm_district, @ca_district]
      District.for_city('San francisco').should =~ [@nm_district, @ca_district]
    end

    it "should handle regular cities" do
      District.for_city('san francisco, ca').should == [@ca_district]
      District.for_city('san FRANCISCO, ca').should == [@ca_district]
    end
  end
end
