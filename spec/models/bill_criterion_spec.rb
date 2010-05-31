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
      delta = 0.009
      1.year.ago.to_date.years_until(Date.today).should be_close(1.0, delta)
      5.years.ago.to_date.years_until(Date.today).should be_close(5.0, delta)
      (5.years + 3.months).ago.to_date.years_until(Date.today).should be_close(5.25, delta)
      (5.years + 3.months + (36.5).days).ago.to_date.years_until(Date.today).should be_close(5.35, delta)
    end
  end

  describe "#rescore_report!" do
    before do
      @report = create_report
    end

    context "on create" do
      it "should be called" do
        criterion = new_bill_criterion(:report => @report)
        mock(@report).rescore!
        criterion.save!
      end
    end

    context "on update" do
      it "should be called if support is changed" do
        criterion = create_bill_criterion(:report => @report, :support => true)
        mock(@report).rescore!
        criterion.update_attributes(:support => false)
      end

      it "should not be called if support is not changed" do
        criterion = create_bill_criterion(:report => @report)
        dont_allow(@report).rescore!
        criterion.update_attributes(:explanatory_url => 'http://google.com')
      end
    end
  end
end
