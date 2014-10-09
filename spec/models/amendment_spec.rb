require File.dirname(__FILE__) + '/../spec_helper'

describe Amendment do
  it "should create a new instance given valid attributes" do
    build(:amendment).save!
  end
end
