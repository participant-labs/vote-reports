require 'spec_helper'

describe ZipCode do
  describe ".zip_code" do
    it "should recognize regular zip codes" do
      expect(ZipCode.zip_code('75028')).to eq('75028')
      expect(ZipCode.zip_code(' 75028')).to eq('75028')
      expect(ZipCode.zip_code('75028  ')).to eq('75028')
    end

    it "should recognize regular zip code + 4" do
      expect(ZipCode.zip_code('75028-1111')).to eq('75028-1111')
      expect(ZipCode.zip_code('75028 1111')).to eq('75028-1111')
      expect(ZipCode.zip_code('750281111')).to eq('75028-1111')
      expect(ZipCode.zip_code('  750281111 ')).to eq('75028-1111')
    end

    it "should not recognize non zips" do
      expect(ZipCode.zip_code('75025-111')).to be_nil
      expect(ZipCode.zip_code('TX')).to be_nil
      expect(ZipCode.zip_code('7502')).to be_nil
      expect(ZipCode.zip_code('7502')).to be_nil
      expect(ZipCode.zip_code('7502-1111')).to be_nil
    end
  end
end
