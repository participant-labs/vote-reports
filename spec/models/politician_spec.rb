require File.dirname(__FILE__) + '/../spec_helper'

describe Politician do
  before do
    @politician = create_politician
  end

  describe "#state" do
    it "should be sourced from the latest term" do
      proc {
        create_representative_term(:state => "TX", :politician => @politician, :ended_on => 1.year.ago)
      }.should change(@politician, :state).to("TX")
      proc {
        create_senate_term(:state => "IA", :politician => @politician, :ended_on => 1.year.from_now)
      }.should change(@politician, :state).to("IA")
    end
  end

  describe "#party" do
    it "should be sourced from the latest term" do
      democratic_party = create_party(:name => "Democrat")
      republican_party = create_party(:name => "Republican")
      proc {
        create_representative_term(:party => democratic_party, :politician => @politician, :ended_on => 1.year.ago)
      }.should change(@politician, :party).to(democratic_party)
      proc {
        create_senate_term(:party => republican_party, :politician => @politician, :ended_on => 1.year.from_now)
      }.should change(@politician, :party).to(republican_party)
    end
  end

  describe "#rolls" do
    before do
      @supported = create_roll
      @opposed = create_roll
      @unconnected = create_roll
      create_vote(:politician => @politician, :roll => @supported, :vote => '+')
      create_vote(:politician => @politician, :roll => @opposed, :vote => '-')
    end

    it "returns all politicians with connecting votes" do
      @politician.rolls.should =~ [@supported, @opposed]
    end

    describe "#supported" do
      it "returns all politicians with supporting votes" do
        @politician.rolls.supported.should =~ [@supported]
      end
    end

    describe "#opposed" do
      it "returns all politicians with supporting votes" do
        @politician.rolls.opposed.should =~ [@opposed]
      end
    end
  end

  describe "#supported/opposed_bills" do
    before do
      @supported = create_roll(:subject => create_bill, :roll_type => 'On Passage')
      @opposed = create_roll(:subject => create_bill, :roll_type => 'On Passage')
      @unconnected = create_roll(:subject => create_bill, :roll_type => 'On Passage')
      create_vote(:politician => @politician, :roll => @supported, :vote => '+')
      create_vote(:politician => @politician, :roll => @opposed, :vote => '-')
    end

    describe "#supported" do
      it "returns all politicians with supporting votes" do
        @politician.supported_bills.should =~ [@supported.subject]
      end
    end

    describe "#opposed" do
      it "returns all politicians with supporting votes" do
        @politician.opposed_bills.should =~ [@opposed.subject]
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
