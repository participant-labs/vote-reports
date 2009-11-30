require File.dirname(__FILE__) + '/../spec_helper'

describe Politician do
  describe "#bills" do
    before(:all) do
      @supported = Factory.create(:bill)
      @opposed = Factory.create(:bill)
      @unconnected = Factory.create(:bill)
      @politician = Factory.create(:politician)
      Factory.create(:vote, :politician => @politician, :bill => @supported, :vote => 1)
      Factory.create(:vote, :politician => @politician, :bill => @opposed, :vote => 0)
    end

    it "returns all politicians with connecting votes" do
      @politician.bills.should =~ [@supported, @opposed]
    end

    describe "#supported" do
      it "returns all politicians with supporting votes" do
        @politician.bills.supported.should =~ [@supported]
      end
    end

    describe "#opposed" do
      it "returns all politicians with supporting votes" do
        @politician.bills.opposed.should =~ [@opposed]
      end
    end
  end
end