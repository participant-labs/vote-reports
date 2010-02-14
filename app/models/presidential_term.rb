class PresidentialTerm < ActiveRecord::Base
  include PoliticianTermStuff

  def title
    "President"
  end

  def place
    "of these United States"
  end
end
