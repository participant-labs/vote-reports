require 'spec/spec_helper'

describe OpenCongress::OCBill do
  before(:all) do
    @bill = OpenCongress::OCBill.by_query('patriot act').first
  end

  describe ".by_query" do
    context "when there are no matches" do
      it "should return an empty array" do
        OpenCongress::OCBill.by_query('smelly roses').should == []
      end
    end
    context "when there are matches" do
      it "should return an array of related bills" do
        bills = OpenCongress::OCBill.by_query('patriot act')
        bills.should be_an_instance_of(Array)
      end
    end
  end

  describe ".by_idents" do
    it "should return an array of related bills" do
      bills = OpenCongress::OCBill.by_idents(["111-h3548"])
      bills.first.title.should == "Worker, Homeownership, and Business Assistance Act of 2009"
    end
  end

  describe "#title_full_common" do
    it "should be present" do
      @bill.title_full_common.should_not be_empty
    end

    it "should be composed of title and bil_number" do
      @bill.title_full_common.should == [@bill.bill_type_human, @bill.title].join(' ')
    end
  end

  describe "#url" do
    it "should point to the bill show page on opencongress" do
      @bill.url.should =~ %r{^http://www\.opencongress\.org/bill/.*/show}
    end
  end
end