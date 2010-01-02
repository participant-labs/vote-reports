class RepresentativeTerm < ActiveRecord::Base
  include Term
  validates_presence_of :state, :district

  def for
    "representing the #{district.ordinalize} district of #{UsState.name_from_abbrev(state)}"
  end
end