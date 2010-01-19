class RepresentativeTerm < PoliticianTerm
  attr_accessible :politician, :district, :state, :started_on, :ended_on, :created_on, :updated_on, :url, :party
  validates_presence_of :state
end