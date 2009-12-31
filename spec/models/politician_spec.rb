require File.dirname(__FILE__) + '/../spec_helper'

describe Politician do
  before do
    @politician = create_politician
  end

  describe "#bills" do
    before do
      @supported = create_roll
      @opposed = create_roll
      @unconnected = create_roll
      create_vote(:politician => @politician, :roll => @supported, :vote => '+')
      create_vote(:politician => @politician, :roll => @opposed, :vote => '-')
    end

    it "returns all politicians with connecting votes" do
      @politician.rolls.should =~ [@supported, @opposed]
      @politician.bills.should =~ [@supported.subject, @opposed.subject]
    end

    describe "#supported" do
      it "returns all politicians with supporting votes" do
        @politician.rolls.supported.should =~ [@supported]
        @politician.bills.supported.should =~ [@supported.subject]
      end
    end

    describe "#opposed" do
      it "returns all politicians with supporting votes" do
        @politician.rolls.opposed.should =~ [@opposed]
        @politician.bills.opposed.should =~ [@opposed.subject]
      end
    end

    it "should return distinct bills" do
      another_supported = create_roll(:subject => @supported.subject)
      create_vote(:politician => @politician, :roll => another_supported, :vote => '+')
      @politician.rolls.supported.should =~ [@supported, another_supported]
      @politician.bills.supported.should =~ [@supported.subject]
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
