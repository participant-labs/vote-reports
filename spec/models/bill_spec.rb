require 'spec_helper'

describe Bill do
  describe ".fetch_by_query" do
    context "when there are no matches" do
      it "should return an empty array" do
        Bill.fetch_by_query("smelly roses").should == []
      end
    end

    context "when there are matches" do
      it "should return bills with titles matching the query" do
        bills = Bill.fetch_by_query("Patriot Act")
        bills.map(&:title).should include("USA PATRIOT Reauthorization Act of 2009")
      end
    end
  end

  describe ".fetch" do
    it "should return bill with the identity in question" do
      bills = Bill.fetch("111-h3548")
      bills.title.should == "Worker, Homeownership, and Business Assistance Act of 2009"
    end
  end

  describe "Creation" do
    it "should fetch votes for this bill" do
      Vote.expects(:fetch_for_bill).at_least_once
      Factory.create(:bill)
    end
  end
end
