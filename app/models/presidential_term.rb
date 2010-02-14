class PresidentialTerm < ActiveRecord::Base
  include PoliticianTerm

  def title
    "President"
  end

  def place
    "of these United States"
  end
end
