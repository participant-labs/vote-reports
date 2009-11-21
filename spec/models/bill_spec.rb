require 'spec_helper'

describe Bill do
  describe ".find" do
    it "should return bills with titles matching the query" do
      bills = Bill.find("Patriot Act")
      bills.map(&:title).should include("USA PATRIOT Reauthorization Act of 2009")
    end
  end
end
