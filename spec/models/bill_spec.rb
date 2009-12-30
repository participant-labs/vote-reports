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

  describe "Updates" do
    before do
      @bill = create_bill(:bill_type => 'h')
    end
    context "when updating congress_id" do
      context "with a new value" do
        it "should blow up" do
          proc {
            @bill.update_attributes(:congress => Congress.find_or_create_by_meeting(@bill.congress.meeting + 1))
          }.should raise_error(ActiveRecord::ReadOnlyRecord)
        end
      end
      context "with the same value" do
        it "should do nothing" do
          proc {
            @bill.update_attributes(:congress => @bill.congress)
          }.should_not raise_error
        end
      end
    end
    context "when updating bill_number" do
      context "with a new value" do
        it "should blow up" do
          proc {
            @bill.update_attributes(:bill_number => @bill.bill_number + 1)
          }.should raise_error(ActiveRecord::ReadOnlyRecord)
        end
      end
      context "with the same value" do
        it "should do nothing" do
          proc {
            @bill.update_attributes(:bill_number => @bill.bill_number)
          }.should_not raise_error
        end
      end
    end
    context "when updating bill_type" do
      context "with a new value" do
        it "should blow up" do
          @bill.bill_type.should_not == 's'
          proc {
            @bill.update_attributes(:bill_type => 's')
          }.should raise_error(ActiveRecord::ReadOnlyRecord)
        end
      end
      context "with the same value" do
        it "should do nothing" do
          proc {
            @bill.update_attributes(:bill_type => @bill.bill_type)
          }.should_not raise_error
        end
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
