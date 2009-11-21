require 'spec_helper'

describe Bill do
  describe ".find_by_query" do
    it "should return bills with titles matching the query" do
      bills = Bill.find_by_query("Patriot Act")
      bills.map(&:title).should include("USA PATRIOT Reauthorization Act of 2009")
    end
  end

  describe ".find" do
    it "should return bill with the identity in question" do
      bills = Bill.find("111-h3548")
      bills.title.should == "Worker, Homeownership, and Business Assistance Act of 2009"
    end
  end
end
