require File.dirname(__FILE__) + '/../spec_helper'

describe BillCriterion do
  before do
    @bill_criterion = create_bill_criterion
  end

  describe "#support=" do
    it "should interpret '1' as true" do
      @bill_criterion.support = '1'
      @bill_criterion.support.should == true
    end

    it "should interpret true as true" do
      @bill_criterion.support = true
      @bill_criterion.support.should == true
    end
  end
end
