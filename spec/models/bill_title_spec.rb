require 'spec_helper'

describe BillTitle do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :title_type => "value for title_type",
      :as => "value for as",
      :bill_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    BillTitle.create!(@valid_attributes)
  end
end
