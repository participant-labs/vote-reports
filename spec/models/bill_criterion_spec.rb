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

  describe "#years_between" do
    it "should calculate years" do
      1.year.ago.to_date.years_until(Date.today).should == 1.0
      5.years.ago.to_date.years_until(Date.today).should == 5.0
      (5.years + 3.months).ago.to_date.years_until(Date.today).should == 5.25
      (5.years + 3.months + (36.5).days).ago.to_date.years_until(Date.today).should be_close(5.35, 0.002)
    end
  end
end
