require 'spec_helper'

describe RepresentativeTerm do
  before do
    @middle = create(:representative_term, ended_on: 1.month.ago)
    @oldest = create(:representative_term, ended_on: 10.years.ago)
    @latest = create(:representative_term, ended_on: 1.year.from_now)
  end

  describe ".by_ended_on" do
    it "should return the terms ordered by .ended_on date" do
      expect(RepresentativeTerm.by_ended_on).to eq([@latest, @middle, @oldest])
    end
  end

  describe ".latest" do
    it "should return the term with the most recent .ended_on date" do
      expect(RepresentativeTerm.latest).to eq(@latest)
    end
  end
end
