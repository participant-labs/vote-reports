class RepresentativeTerm < PoliticianTerm
  attr_accessible :politician, :district, :state, :started_on, :ended_on, :created_on, :updated_on, :url, :party
  validates_presence_of :state

  def title
    "#{'Delegate ' if state.unincorporated? }Representative"
  end

  def place
    district = self.district == 0 ? 'at-large' : self.district.ordinalize if self.district
    district = "the #{district} district of " if district
    "for #{district}#{state.full_name}"
  end
end