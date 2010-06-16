require 'spec_helper'

describe ZipCode do
  describe ".zip_code" do
    it "should recognize regular zip codes" do
      ZipCode.zip_code('75028').should == '75028'
      ZipCode.zip_code(' 75028').should == '75028'
      ZipCode.zip_code('75028  ').should == '75028'
    end

    it "should recognize regular zip code + 4" do
      ZipCode.zip_code('75028-1111').should == '75028-1111'
      ZipCode.zip_code('75028 1111').should == '75028-1111'
      ZipCode.zip_code('750281111').should == '75028-1111'
      ZipCode.zip_code('  750281111 ').should == '75028-1111'
    end

    it "should not recognize non zips" do
      ZipCode.zip_code('75025-111').should == nil
      ZipCode.zip_code('TX').should == nil
      ZipCode.zip_code('7502').should == nil
      ZipCode.zip_code('7502').should == nil
      ZipCode.zip_code('7502-1111').should == nil
    end
  end
end
