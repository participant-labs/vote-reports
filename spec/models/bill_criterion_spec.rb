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
      1.year.ago.to_date.years_until(Date.today).should be_within(delta).of(1.0)
      5.years.ago.to_date.years_until(Date.today).should be_within(delta).of(5.0)
      (5.years + 3.months).ago.to_date.years_until(Date.today).should be_within(delta).of(5.25)
      (5.years + 3.months + (36.5).days).ago.to_date.years_until(Date.today).should be_within(delta).of(5.35)
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

  describe ".autofetch!" do
    context "when there are no support or oppose images" do
      it "should assume support for the the entries" do
        BillCriterion.autofetch_from(Rails.root.join('spec/fixtures/files/capwiz/thearc.html')).should include({
          "S. 3304 - Equal Access to 21st Century Communications Act  of  2010" => {:support => true, :explanatory_url => 'http://capwiz.com/thearc/issues/bills/?bill=15116426'}
        })
      end
    end

    context "from a customized html source" do
      it "should extract supported/opposed bill names and positions" do
        BillCriterion.autofetch_from(Rails.root.join('spec/fixtures/files/capwiz/consumer_action.html')).should include({
          "S. 1799 - FAIR Overdraft Coverage Act" => {:support => true, :explanatory_url => 'http://capwiz.com/consumeraction/issues/bills/?bill=14361426'},
          "S. 202 - Passenger Vehicle Loss Disclosure Act" => {:support => false, :explanatory_url => 'http://capwiz.com/consumeraction/issues/bills/?bill=13009046'},
          "H.R. 5381 - Motor Vehicle Safety Act of 2010" => {:support => true, :explanatory_url => 'http://capwiz.com/consumeraction/issues/bills/?bill=16046886'},
          "S. 399 - Credit Card Holder's Bill of Rights" => {:support => true, :explanatory_url => 'http://capwiz.com/consumeraction/issues/bills/?bill=12896581'},
          "S. 392 - Credit card consumer protections" => {:support => true, :explanatory_url => 'http://capwiz.com/consumeraction/issues/bills/?bill=12896561'},
          "S. 165 - Student credit card protections" => {:support => true, :explanatory_url => 'http://capwiz.com/consumeraction/issues/bills/?bill=12896391'},
          "S. 131 - Credit card mimimum payment notice" => {:support => true, :explanatory_url => 'http://capwiz.com/consumeraction/issues/bills/?bill=12896616'}
        })
      end

      it "should not include those with dashes or monitoring" do
        BillCriterion.autofetch_from(Rails.root.join('spec/fixtures/files/capwiz/consumer_action.html')).keys.should_not include(
          "H.R. 1880 - Insurance consumer protection",
          "H.R. 111 - Prevent banks from real estate brokerage/management",
          "S. 486 - Access for all to comprehensive primary health care services",
          "S. 436 - Youth safety on the Internet",
          "S. 348 - Universal service contributions"
        )
      end
    end

    context "from a standard source" do
      it "should extract supported/opposed bill names and positions" do
        BillCriterion.autofetch_from(Rails.root.join('spec/fixtures/files/capwiz/adc.html')).should include({
          "S. 416 - 'A bill to limit the use of cluster munitions. '" => {:support => true, :explanatory_url => 'http://capwiz.com/adc/issues/bills/?bill=12956486'},
          "H.R. 1206 - 'To strengthen sanctions against the Government of Syria, to enhance multilateral commitment to address the Government of Syria''s threatening policies, to establish a program to support a transition to a democratically-elected government in Syria, and for other purposes. '" => {:support => false, :explanatory_url => 'http://capwiz.com/adc/issues/bills/?bill=12943491'}
        })
      end
    end
  end
end
