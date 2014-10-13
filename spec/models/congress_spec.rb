require 'rails_helper'

RSpec.describe Congress do
  describe ".current_meeting" do
    it "should return the proper meeting based on the current date" do
      {
        "9/1/2009" => 111,
        "9/1/2010" => 111,
        "2/1/1993" => 102,
        "3/1/1993" => 103,
        "4/1/1993" => 103,
        "3/1/1994" => 103,
        "2/1/1997" => 104,
        "3/1/1997" => 105
      }.each do |date, meeting|
        allow(Date).to receive(:today).and_return(Date.parse(date))
        expect(Congress.current_meeting).to eq(meeting)
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
