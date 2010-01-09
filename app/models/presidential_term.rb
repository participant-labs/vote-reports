class PresidentialTerm < PoliticianTerm
  attr_accessible :politician, :started_on, :ended_on, :created_on, :updated_on, :url, :party

  def for
    'the President of these United States'
  end
end
