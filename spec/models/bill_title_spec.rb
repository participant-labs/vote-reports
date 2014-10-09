require 'spec_helper'

describe BillTitle do
  def as(name)
    BillTitleAs.find_by_as!(name)
  end

  describe "default scope" do
    it "should return short before official titles" do
      short = create(:bill_title, as: as(:enacted), title_type: 'short')
      create(:bill_title, as: as(:enacted), title_type: 'official')

      BillTitle.first.should == short
    end

    it "should return enacted before popular" do
      create(:bill_title, as: as(:popular), title_type: 'official')
      enacted = create(:bill_title, as: as(:enacted), title_type: 'official')

      BillTitle.first.should == enacted
    end
  end
end
