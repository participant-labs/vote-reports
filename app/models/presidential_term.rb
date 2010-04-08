class PresidentialTerm < ActiveRecord::Base
  include PoliticianTerm

  def title
    "President"
  end
end
