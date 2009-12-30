class RepresentativeTerm < ActiveRecord::Base
  belongs_to :politician

  validates_presence_of :politician, :state, :district

  def for
    "representing the #{district.ordinalize} district of #{UsState.name_from_abbrev(state)}"
  end
end