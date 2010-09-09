require 'spec_helper'

describe CongressionalDistrict do
  describe ".for_city" do
    before do
      @nm_district = create_congressional_district(:state => create_us_state(:abbreviation => 'NM'))
      @ca_district = create_congressional_district(:state => create_us_state(:abbreviation => 'CA'))
      @nm_district.zip_codes << create_zip_code(:zip_code => '11111')
      @ca_district.zip_codes << create_zip_code(:zip_code => '22222')
      create_location(:city => 'SAN FRANCISCO', :state => 'CA', :zip_code => '22222')
      create_location(:city => 'SAN FRANCISCO', :state => 'NM', :zip_code => '11111')
    end

    it "should handle cities alone" do
      CongressionalDistrict.for_city('san francisco').should =~ [@nm_district, @ca_district]
      CongressionalDistrict.for_city('San francisco').should =~ [@nm_district, @ca_district]
    end

    it "should handle regular cities" do
      CongressionalDistrict.for_city('san francisco, ca').should == [@ca_district]
      CongressionalDistrict.for_city('san FRANCISCO, ca').should == [@ca_district]
    end
  end
end
