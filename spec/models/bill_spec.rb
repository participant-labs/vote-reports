require File.dirname(__FILE__) + '/../spec_helper'

RSpec.describe Bill do
  describe ".search", :solr do
    before do
      bill = create(:bill)
      create(:bill_title, bill: bill, title: "USA PATRIOT Reauthorization Act of 2009")
    end

    context "when there are no matches" do
      it "should return an empty array" do
        expect(Bill.search { fulltext "smelly roses" }.results).to eq([])
      end
    end

    context "when there are matches" do
      it "should return bills with titles matching the query" do
        bills = Bill.search { fulltext "Reauthorization" }
        expect(bills.results.map {|bill| bill.titles.first.to_s }).to include("USA PATRIOT Reauthorization Act of 2009")
      end
    end

    it "should match on bill number" do
      bill = create(:bill, bill_number: 4472)
      Bill.solr_reindex
      expect(Bill.search { fulltext "4472" }.results).to eq([bill])
    end
  end

  describe "Validations" do
    it "should validate presence of introduced_on" do
      expect {
        create(:bill, introduced_on: nil)
      }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end

  describe "Updates" do
    before do
      @bill = create(:bill, bill_type: 'h')
    end
    context "when updating congress_id" do
      context "with a new value" do
        it "should blow up" do
          expect {
            @bill.update_attributes(congress: Congress.find_or_create_by(meeting: @bill.congress.meeting + 1))
          }.to raise_error(ActiveRecord::ReadOnlyRecord)
        end
      end
      context "with the same value" do
        it "should do nothing" do
          expect {
            @bill.update_attributes(congress: @bill.congress)
          }.to_not raise_error
        end
      end
    end
    context "when updating bill_number" do
      context "with a new value" do
        it "should blow up" do
          expect {
            @bill.update_attributes(bill_number: @bill.bill_number + 1)
          }.to raise_error(ActiveRecord::ReadOnlyRecord)
        end
      end
      context "with the same value" do
        it "should do nothing" do
          expect {
            @bill.update_attributes(bill_number: @bill.bill_number)
          }.to_not raise_error
        end
      end
      context "with an equivalent value" do
        it "should do nothing" do
          expect {
            @bill.update_attributes(bill_number: @bill.bill_number.to_s)
          }.to_not raise_error
        end
      end
    end
    context "when updating bill_type" do
      context "with a new value" do
        it "should blow up" do
          expect(@bill.bill_type).to_not eq('s')
          expect {
            @bill.update_attributes(bill_type: 's')
          }.to raise_error(ActiveRecord::ReadOnlyRecord)
        end
      end
      context "with the same value" do
        it "should do nothing" do
          expect {
            @bill.update_attributes(bill_type: @bill.bill_type)
          }.to_not raise_error
        end
      end
    end
  end

  describe ".by_introduced_on" do
    it "should return bills with the most recent first" do
      bill1 = create(:bill, introduced_on: 1.year.ago)
      bill2 = create(:bill, introduced_on: 2.years.ago)
      bill3 = create(:bill, introduced_on: 1.month.ago)
      expect(Bill.by_introduced_on).to eq([bill3, bill1, bill2])
    end
  end

  describe "#politicians" do
    before do
      @supporting = create(:politician)
      @opposing = create(:politician)
      @unconnected = create(:politician)
      @bill = create(:bill)
      @roll = create(:roll, subject: @bill)
      create(:vote, politician: @supporting, roll: @roll, vote: '+')
      create(:vote, politician: @opposing, roll: @roll, vote: '-')
    end

    it "returns all politicians with connecting votes" do
      expect(@bill.politicians.to_a).to match_array([@supporting, @opposing])
    end

    describe "#supporting" do
      it "returns all politicians with supporting votes" do
        expect(@bill.politicians.supporting).to eq([@supporting])
      end
    end

    describe "#opposing" do
      it "returns all politicians with supporting votes" do
        expect(@bill.politicians.opposing).to eq([@opposing])
      end
    end
  end
end
