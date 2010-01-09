require File.dirname(__FILE__) + '/../spec_helper'

describe Congress do
  describe ".current_meeting" do
    it "should return the proper meeting based on the current date" do
      {
        "1/9/2009" => 111,
        "1/9/2010" => 111,
        "1/2/1993" => 102,
        "1/3/1993" => 103,
        "1/4/1993" => 103,
        "1/3/1994" => 103,
        "1/2/1997" => 104,
        "1/3/1997" => 105
      }.each do |date, meeting|
        date = Date.parse(date)
        stub(Date).today { date }
        Congress.current_meeting.should == meeting
      end
    end
  end

  describe "#senators" do
    it "should return the senators in office during this Congress"
  end

  describe "#representatives" do
    it "should return the representatives in office during this Congress"
  end

  describe "#presidents" do
    it "should return the presidents in office during this Congress"
  end
end
