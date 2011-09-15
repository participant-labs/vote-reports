class RepresentativeTerm < ActiveRecord::Base
  include PoliticianTerm

  belongs_to :congressional_district
  delegate :state, to: :congressional_district

  validates_presence_of :congressional_district, :state
  alias_attribute :location, :congressional_district

  def title
    "#{'Delegate ' if state.unincorporated? }Representative"
  end
end
