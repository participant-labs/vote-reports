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

    it "should recognize zip_codes with incomplete + 4" do
      helper.zip_code?('75025-111').should == true
    end

    it "should not recognize non zips" do
      helper.zip_code?('TX').should == false
      helper.zip_code?('7502').should == false
      helper.zip_code?('7502').should == false
      helper.zip_code?('7502-1111').should == false
    end
  end

end
