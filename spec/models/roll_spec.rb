require File.dirname(__FILE__) + '/../spec_helper'

describe Roll do
  describe ".by_voted_at" do
    before do
      @recent = create_roll(:voted_at => 1.week.ago)
      @old = create_roll(:voted_at => 1.year.ago)
      @middle = create_roll(:voted_at => 3.months.ago)
      @nil = create_roll(:voted_at => nil)
    end

    it "should order by vote date, with the most recent first" do
      Roll.by_voted_at.should == [@recent, @middle, @old, @nil]
    end
  end
end