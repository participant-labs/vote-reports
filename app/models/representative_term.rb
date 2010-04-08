class RepresentativeTerm < ActiveRecord::Base
  include PoliticianTerm

  belongs_to :district
  delegate :state, :to => :district

  validates_presence_of :district, :state
  alias_attribute :location, :district

  def title
    "#{'Delegate ' if state.unincorporated? }Representative"
  end
end