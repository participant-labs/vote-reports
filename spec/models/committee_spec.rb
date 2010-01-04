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
end
