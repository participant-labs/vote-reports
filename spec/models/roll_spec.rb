require File.dirname(__FILE__) + '/../spec_helper'

describe Roll do
  describe ".by_voted_at" do
    before do
      @recent = create(:roll, voted_at: 1.week.ago)
      @old = create(:roll, voted_at: 1.year.ago)
      @middle = create(:roll, voted_at: 3.months.ago)
    end

    it "should order by vote date, with the most recent first" do
      Roll.by_voted_at.should == [@recent, @middle, @old]
    end
  end

  describe "friendly_id" do
    it "should work" do
      roll = create(:roll, year: 1990, number: 5, where: 'house')
      roll.friendly_id.should == '1990-h5'
      Roll.find('1990-h5').should == roll
    end

    it "should allow search by actual id" do
      roll = create(:roll, year: 1990, number: 5, where: 'house')
      Roll.find(roll.id).should == roll
    end
  end
end
