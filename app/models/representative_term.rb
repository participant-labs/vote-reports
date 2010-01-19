class RepresentativeTerm < PoliticianTerm
  attr_accessible :politician, :district, :state, :started_on, :ended_on, :created_on, :updated_on, :url, :party
  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id
  validates_presence_of :state
end