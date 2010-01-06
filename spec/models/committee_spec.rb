require 'spec_helper'

describe Committee do
  before(:each) do
    @valid_attributes = {
      :chamber => "value for chamber",
      :code => "value for code",
      :name => "value for name",
      :thomas_name => "value for thomas_name",
      :ancestry => "value for ancestry"
    }
  end

  it "should create a new instance given valid attributes" do
    Committee.create!(@valid_attributes)
  end

  describe ".find_by_name" do
    it "should return committee with this name" do
      committee = create_committee
      create_committee_name(:committee => committee, :name => 'sought')
      Committee.find_by_name('sought').should == committee
    end
  end
end
