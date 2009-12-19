require File.dirname(__FILE__) + '/../spec_helper'

describe Bill do
  describe ".search" do
    integrate_sunspot
    before do
      Bill.make(:title => "USA PATRIOT Reauthorization Act of 2009").index
    end

    context "when there are no matches" do
      it "should return an empty array" do
        Bill.search { fulltext "smelly roses" }.results.should == []
      end
    end

    context "when there are matches" do
      it "should return bills with titles matching the query" do
        bills = Bill.search { fulltext "PATRIOT" }
        pending "Interaction between friendly_id and sunspot?"
        bills.results.map(&:title).should include("USA PATRIOT Reauthorization Act of 2009")
      end
    end
  end

  describe ".recent" do
    it "should return bills with the most recent first" do
      prior_bills = Bill.recent.all
      bill1 = Bill.make
      bill2 = Bill.make
      bill3 = Bill.make
      Bill.recent.should == [bill3, bill2, bill1, *prior_bills]
    end
  end

  describe "#politicians" do
    before(:all) do
      @supporting = Politician.make
      @opposing = Politician.make
      @unconnected = Politician.make
      @bill = Bill.make
      @roll = Roll.make(:subject => @bill)
      Vote.make(:politician => @supporting, :roll => @roll, :vote => '+')
      Vote.make(:politician => @opposing, :roll => @roll, :vote => '-')
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
