require File.dirname(__FILE__) + '/../spec_helper'

describe Politician do
  before do
    @politician = create(:politician)
  end

  describe ".from" do
    context "with an unknown location" do
      it "should not return nil" do
        Politician.from('Tokyo, Japan').should_not be_nil
      end

      it "should return an empty set" do
        Politician.from('Tokyo, Japan').should be_empty
      end
    end
  end

  describe "#state" do
    it "should be sourced from the latest term" do
      state = UsState.all.sample
      @politician.state.should_not == state
      proc {
        create(:representative_term, congressional_district: create(:congressional_district, state: state), politician: @politician, ended_on: 1.year.ago)
      }.should change(@politician, :state).to(state)
      new_state = UsState.all.sample
      proc {
        create(:senate_term, state: new_state, politician: @politician, ended_on: 1.year.from_now)
      }.should change(@politician, :state).to(new_state)
    end
  end

  describe "#rolls" do
    before do
      @supported = create(:roll)
      @opposed = create(:roll)
      @unconnected = create(:roll)
      create(:vote, politician: @politician, roll: @supported, vote: '+')
      create(:vote, politician: @politician, roll: @opposed, vote: '-')
    end

    it "returns all politicians with connecting votes" do
      @politician.rolls.should =~ [@supported, @opposed]
    end

    describe "#supported" do
      it "returns all politicians with supporting votes" do
        @politician.rolls.supported.should == [@supported]
      end
    end

    describe "#opposed" do
      it "returns all politicians with supporting votes" do
        @politician.rolls.opposed.should == [@opposed]
      end
    end
  end

  describe "#headshot" do
    def gov_track_url(path)
      %r{^http://www.govtrack.us/data/#{path}$}
    end

    context "with no argument" do
      it "should return the url of the largest available headshot" do
        @politician.headshot.url.to_s.should =~ gov_track_url("photos/#{@politician.gov_track_id}.jpeg")
      end
    end

    context "with size argument" do
      it "should return an equivalent url" do
        {large: 200, medium: 100, small: 50}.each_pair do |arg, width|
          @politician.headshot.url(arg).should =~ gov_track_url("photos/#{@politician.gov_track_id}-#{width}px.jpeg")
        end
      end
    end
  end

  describe "#firstname=" do
    it "should set first_name" do
      Politician.new(firstname: 'Bill').first_name.should == 'Bill'
    end
  end
end
