require 'rails_helper'

RSpec.describe CongressionalDistrict do
  def zip_code(number)
    ZipCode.find_or_create_by(zip_code: number)
  end

  describe ".for_city" do
    before do
      @nm_district = create(:congressional_district, state: us_states(:nm))
      @ca_district = create(:congressional_district, state: us_states(:ca))
      @nm_district.zip_codes << zip_code('11111')
      @ca_district.zip_codes << zip_code('22222')
      create(:location, city: 'SAN FRANCISCO', state: 'CA', zip_code: zip_code('22222'))
      create(:location, city: 'SAN FRANCISCO', state: 'NM', zip_code: zip_code('11111'))
    end

    context "when a city is supplied" do
      it "should return districts for any such city, regardless of state" do
        expect(CongressionalDistrict.for_city('san francisco').to_a).to match_array([@nm_district, @ca_district])
        expect(CongressionalDistrict.for_city('San francisco').to_a).to match_array([@nm_district, @ca_district])
      end
    end

    context "when a city & state is supplied" do
      it "should handle regular cities" do
        expect(CongressionalDistrict.for_city('san francisco, ca')).to eq([@ca_district])
        expect(CongressionalDistrict.for_city('san FRANCISCO, ca')).to eq([@ca_district])
      end

      it "should not return results from bordering states even when they have the same zip code" do
        borders_ca_district = create(:congressional_district, state: us_states(:az))
        borders_ca_district.zip_codes << @ca_district.zip_codes.first
        expect(CongressionalDistrict.for_city('san francisco, ca')).to_not include(borders_ca_district)
      end
    end
  end
end
