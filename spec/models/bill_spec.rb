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

  describe "#politicians" do
    before(:all) do
      @supporting = Factory.create(:politician)
      @opposing = Factory.create(:politician)
      @unconnected = Factory.create(:politician)
      @bill = Factory.create(:bill)
      Factory.create(:vote, :politician => @supporting, :bill => @bill, :vote => 1)
      Factory.create(:vote, :politician => @opposing, :bill => @bill, :vote => 0)
    end

    it "returns all politicians with connecting votes" do
      @bill.politicians.should =~ [@supporting, @opposing]
    end

    describe "#supporting" do
      it "returns all politicians with supporting votes" do
        @bill.politicians.supporting.should =~ [@supporting]
      end
    end

    describe "#opposing" do
      it "returns all politicians with supporting votes" do
        @bill.politicians.opposing.should =~ [@opposing]
      end
    end
  end
end
