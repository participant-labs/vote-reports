require File.dirname(__FILE__) + '/../spec_helper'

describe BillType do
  describe "#to_s" do
    it "should return the short name, rather than code for the type" do
      BillType.new('h').to_s.should == 'H.R.'
    end
  end
end
