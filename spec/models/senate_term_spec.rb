require 'spec_helper'

describe SenateTerm do
  before do
    @middle = create_senate_term(ended_on: 1.month.ago)
    @oldest = create_senate_term(ended_on: 10.years.ago)
    @latest = create_senate_term(ended_on: 1.year.from_now)
  end

  describe ".by_ended_on" do
    it "should return the terms ordered by .ended_on date" do
      SenateTerm.by_ended_on.should == [@latest, @middle, @oldest]
    end
  end

  describe ".latest" do
    it "should return the term with the most recent .ended_on date" do
      SenateTerm.latest.should == @latest
    end
  end
end
