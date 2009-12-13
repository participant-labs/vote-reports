require File.dirname(__FILE__) + '/../spec_helper'

describe Politician do
  before do
    @politician = Factory.create(:politician)
  end

  describe "#bills" do
    before do
      @supported = Factory.create(:bill)
      @opposed = Factory.create(:bill)
      @unconnected = Factory.create(:bill)
      Factory.create(:vote, :politician => @politician, :bill => @supported, :vote => 1)
      Factory.create(:vote, :politician => @politician, :bill => @opposed, :vote => 0)
    end

    it "returns all politicians with connecting votes" do
      @politician.bills.should =~ [@supported, @opposed]
    end

    describe "#supported" do
      it "returns all politicians with supporting votes" do
        @politician.bills.supported.should =~ [@supported]
      end
    end

    describe "#opposed" do
      it "returns all politicians with supporting votes" do
        @politician.bills.opposed.should =~ [@opposed]
      end
    end
  end

  describe "#headshot" do
    def gov_track_url(path)
      %r{^http://www.govtrack.us/data/#{path}$}
    end

    context "with no argument" do
      it "should return the url of the largest available headshot" do
        @politician.headshot_url.to_s.should =~ gov_track_url("photos/#{@politician.gov_track_id}.jpeg")
      end
    end

    context "with size argument" do
      it "should return an equivalent url" do
        {:large => 200, :medium => 100, :small => 50}.each_pair do |arg, width|
          @politician.headshot_url(arg).should =~ gov_track_url("photos/#{@politician.gov_track_id}-#{width}px.jpeg")
        end
      end
    end
  end

  describe "#firstname=" do
    it "should set first_name" do
      Politician.new(:firstname => 'Bill').first_name.should == 'Bill'
    end
  end
end
