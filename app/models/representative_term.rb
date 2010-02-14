class RepresentativeTerm < ActiveRecord::Base
  include PoliticianTerm

  belongs_to :district
  delegate :state, :to => :district

  validates_presence_of :district

  def title
    "#{'Delegate ' if state.unincorporated? }Representative"
  end

  def place
    district = self.district == 0 ? 'at-large' : self.district.ordinalize if self.district
    district = "the #{district} district of " if district
    "for #{district}#{state.full_name}"
  end
end