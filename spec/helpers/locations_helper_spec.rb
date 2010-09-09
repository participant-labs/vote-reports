require 'spec_helper'

describe LocationsHelper do

  describe "sought_politicians" do
    before do
      @geo = Object.new
      stub(@geo).full_address { 'geo' }
      stub(@geo).is_us? { true }
      stub(@geo).city { 'Seattle' }
      stub(@geo).state { 'WA' }
      stub(@geo).zip { '98101' }
    end

    context "when representing param is set" do
      before do
        params[:representing] = 'param'
      end

      it "should be favored over session" do
        session[:zip_code] = 'zip'
        mock(Politician).from('param') { Politician }
        helper.sought_politicians
      end

      it "should be favored over geolocation" do
        session[:geo_location] = @geo
        mock(Politician).from('param') { Politician }
        helper.sought_politicians
      end

      it "should be used when alone" do
        mock(Politician).from('param') { Politician }
        helper.sought_politicians
      end
    end

    context "when geocode has results" do
      before do
        session[:geo_location] = @geo
      end

      it "should defer to representing" do
        params[:representing] = 'param'
        mock(Politician).from('param') { Politician }
        helper.sought_politicians
      end

      it "should defer to blank representing" do
        params[:representing] = ''
        mock(Politician).from('') { Politician }
        helper.sought_politicians
      end

      it "should be used when alone" do
        mock(Politician).from_location(@geo) { Politician }
        helper.sought_politicians
      end
    end
  end

end
