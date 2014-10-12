require 'rails_helper'

RSpec.describe LocationsHelper do

  describe "sought_politicians" do
    let(:geo) {
      double(:geo,
        full_address: 'geo',
        is_us?: true,
        city: 'Seattle', state: 'WA', zip: '98101')
    }

    subject(:sought_politicians) {
      helper.sought_politicians
    }

    context "when representing param is set" do
      before do
        params[:representing] = 'param'
      end

      it "is favored over session" do
        session[:zip_code] = 'zip'
        expect(Politician).to receive(:from).with('param').and_return(Politician)
        sought_politicians
      end

      it "is favored over geolocation" do
        session[:geo_location] = geo
        expect(Politician).to receive(:from).with('param').and_return(Politician)
        sought_politicians
      end

      it "is used when alone" do
        expect(Politician).to receive(:from).with('param').and_return(Politician)
        sought_politicians
      end
    end

    context "when geocode has results" do
      before do
        session[:geo_location] = geo
      end

      it "defers to representing" do
        params[:representing] = 'param'
        expect(Politician).to receive(:from).with('param').and_return(Politician)
        sought_politicians
      end

      it "defers to blank representing" do
        params[:representing] = ''
        expect(Politician).to receive(:from).with('').and_return(Politician)
        sought_politicians
      end

      it "is used when alone" do
        expect(Politician).to receive(:from_location).with(geo).and_return(Politician)
        sought_politicians
      end
    end
  end

end
