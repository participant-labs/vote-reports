class PresidentialTerm < ActiveRecord::Base
  include PoliticianTerm

  def title
    "President"
  end

  def location
    nil
  end
end
