require 'rails_helper'

RSpec.describe Amendment do
  it "should create a new instance given valid attributes" do
    build(:amendment).save!
  end
end
