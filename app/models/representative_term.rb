class RepresentativeTerm < ActiveRecord::Base
  belongs_to :politician
  belongs_to :congress

  validates_presence_of :politician, :congress

  def for
    "representing the #{district.ordinalize} district of #{UsState.name_from_abbrev(state)}"
  end
end