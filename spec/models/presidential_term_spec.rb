require 'spec_helper'

describe PresidentialTerm do
  before(:each) do
    @valid_attributes = {
      :politician_id => 1,
      :started_on => Date.today,
      :ended_on => Date.today,
      :party => "value for party",
      :url => "value for url"
    }
  end

  it "should create a new instance given valid attributes" do
    PresidentialTerm.create!(@valid_attributes)
  end
end
