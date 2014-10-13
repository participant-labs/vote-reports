require 'rails_helper'

RSpec.describe Roll do
  describe ".by_voted_at" do
    before do
      @recent = create(:roll, voted_at: 1.week.ago)
      @old = create(:roll, voted_at: 1.year.ago)
      @middle = create(:roll, voted_at: 3.months.ago)
    end

    it "should order by vote date, with the most recent first" do
      expect(Roll.by_voted_at).to eq([@recent, @middle, @old])
    end
  end

  describe "friendly_id" do
    it "should work" do
      roll = create(:roll, year: 1990, number: 5, where: 'house')
      expect(roll.friendly_id).to eq('1990-h5')
      expect(Roll.friendly.find('1990-h5')).to eq(roll)
    end

    it "should allow search by actual id" do
      roll = create(:roll, year: 1990, number: 5, where: 'house')
      expect(Roll.find(roll.id)).to eq(roll)
    end
  end
end
