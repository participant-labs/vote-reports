require 'term'

class RepresentativeTerm < ActiveRecord::Base
  acts_as_term
  validates_presence_of :state, :district

  def for
    "representing the #{district.ordinalize} district of #{UsState.name_from_abbrev(state)}"
  end
end