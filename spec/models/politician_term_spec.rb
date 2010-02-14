require 'spec_helper'

describe PoliticianTerm do
  before do
    @senate = @middle = create_senate_term(:ended_on => 1.month.ago)
    @presidential = @oldest = create_presidential_term(:ended_on => 10.years.ago)
    @representative = @latest = create_representative_term(:ended_on => 1.year.from_now)
  end

  describe ".by_ended_on" do
    it "should return the terms ordered by .ended_on date" do
      PoliticianTerm.by_ended_on.should == [@latest, @middle, @oldest]
    end
  end

  describe ".latest" do
    it "should return the term with the most recent .ended_on date" do
      PoliticianTerm.latest.should == @latest
    end
  end
end
