require 'spec_helper'

describe LocationsHelper do

  describe "zip_code?" do
    it "should recognize regular zip codes" do
      helper.zip_code?('75028').should == true
      helper.zip_code?(' 75028').should == true
      helper.zip_code?('75028  ').should == true
    end

    it "should recognize regular zip code + 4" do
      helper.zip_code?('75028-1111').should == true
      helper.zip_code?('75028 1111').should == true
      helper.zip_code?('750281111').should == true
      helper.zip_code?('  750281111 ').should == true
    end

    it "should not recognize non zips" do
      helper.zip_code?('75025-111').should == false
      helper.zip_code?('TX').should == false
      helper.zip_code?('7502').should == false
      helper.zip_code?('7502').should == false
      helper.zip_code?('7502-1111').should == false
    end
  end

  describe "sought_politicians" do
    before do
      @geo = Object.new
      stub(@geo).full_address { 'geo' }
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

    context "when zip code is set" do
      before do
        session[:zip_code] = 'zip'
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

      it "should be favored over geolocation" do
        session[:geo_location] = @geo
        mock(Politician).from('zip') { Politician }
        helper.sought_politicians
      end

      it "should be used when alone" do
        mock(Politician).from('zip') { Politician }
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

      it "should defer to zip code" do
        session[:zip_code] = 'zip'
        mock(Politician).from('zip') { Politician }
        helper.sought_politicians
      end

      it "should be used when alone" do
        mock(Politician).from(@geo) { Politician }
        helper.sought_politicians
      end
    end
  end

end
