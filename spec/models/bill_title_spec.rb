require 'spec_helper'

describe BillTitle do
  describe "default scope" do
    it "should return short before official titles" do
      short = create_bill_title(as: 'enacted', title_type: 'short')
      create_bill_title(as: 'enacted', title_type: 'official')

      BillTitle.first.should == short
    end

    it "should return enacted before popular" do
      create_bill_title(as: 'popular', title_type: 'official')
      enacted = create_bill_title(as: 'enacted', title_type: 'official')

      BillTitle.first.should == enacted
    end
  end
end
