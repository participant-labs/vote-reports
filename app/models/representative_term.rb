class RepresentativeTerm < PoliticianTerm
  attr_accessible :politician, :district, :state, :started_on, :ended_on, :created_on, :updated_on, :url, :party
  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id
  validates_presence_of :state

  def title
    "#{'Delegate ' if state.unincorporated? }Representative"
  end

  def district
    self[:district] == 0 ? 'at-large' : self[:district].ordinalize
  end

  def place
    district = "the #{self.district} district of " if self.district
    "for #{district}#{state.full_name}"
  end
end