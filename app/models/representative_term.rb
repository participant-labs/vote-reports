class RepresentativeTerm < Term
  attr_accessible :politician, :district, :state, :started_on, :ended_on, :created_on, :updated_on, :url, :party
  validates_presence_of :state, :district

  def for
    "representing the #{district.ordinalize} district of #{UsState.name_from_abbrev(state)}"
  end
end