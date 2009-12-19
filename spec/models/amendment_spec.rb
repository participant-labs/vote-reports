require File.dirname(__FILE__) + '/../spec_helper'

describe Amendment do
  it "should create a new instance given valid attributes" do
    Amendment.make.save!
  end
end
