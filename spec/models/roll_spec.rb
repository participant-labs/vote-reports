require File.dirname(__FILE__) + '/../spec_helper'

describe Roll do
  describe "default scope" do
    it "should order by vote date, with the most recent first" do
      create_roll(:voted_at => 6.months.ago)
      recent = create_roll(:voted_at => 1.week.ago)
      old = create_roll(:voted_at => 1.year.ago)
      create_roll(:voted_at => 3.months.ago)
      Roll.first.should == recent
      Roll.last.should == old
    end
  end
end