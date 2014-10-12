require 'rails_helper'

RSpec.describe SenateTerm do
  before do
    @middle = create(:senate_term, ended_on: 1.month.ago)
    @oldest = create(:senate_term, ended_on: 10.years.ago)
    @latest = create(:senate_term, ended_on: 1.year.from_now)
  end

  describe ".by_ended_on" do
    it "should return the terms ordered by .ended_on date" do
      expect(SenateTerm.by_ended_on).to eq([@latest, @middle, @oldest])
    end
  end

  describe ".latest" do
    it "should return the term with the most recent .ended_on date" do
      expect(SenateTerm.latest).to eq(@latest)
    end
  end
end
