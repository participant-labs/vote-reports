require File.dirname(__FILE__) + '/../spec_helper'

describe Bill do
  describe ".search" do
    integrate_sunspot
    before do
      create_bill(:title => "USA PATRIOT Reauthorization Act of 2009")
      Bill.reindex
    end

    context "when there are no matches" do
      it "should return an empty array" do
        Bill.search { fulltext "smelly roses" }.results.should == []
      end
    end

    context "when there are matches" do
      it "should return bills with titles matching the query" do
        bills = Bill.search { fulltext "Reauthorization" }
        bills.results.map(&:title).should include("USA PATRIOT Reauthorization Act of 2009")
      end
    end
  end

  describe ".recent" do
    it "should return bills with the most recent first" do
      prior_bills = Bill.recent.all
      bill1 = create_bill
      bill2 = create_bill
      bill3 = create_bill
      Bill.recent.should == [bill3, bill2, bill1, *prior_bills]
    end
  end

  describe "#politicians" do
    before(:all) do
      @supporting = create_politician
      @opposing = create_politician
      @unconnected = create_politician
      @bill = create_bill
      @roll = create_roll(:subject => @bill)
      create_vote(:politician => @supporting, :roll => @roll, :vote => '+')
      create_vote(:politician => @opposing, :roll => @roll, :vote => '-')
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
