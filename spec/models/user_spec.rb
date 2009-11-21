require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it "should be created with valid attributes" do
    lambda do
      Factory(:user)
    end.should change(User,:count).by(1)
  end
end
