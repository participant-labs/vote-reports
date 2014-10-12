require File.dirname(__FILE__) + '/../spec_helper'

RSpec.describe BillType do
  describe "#to_s" do
    it "should return the short name, rather than code for the type" do
      expect(BillType.new('h').to_s).to eq('H.R.')
    end
  end
end
