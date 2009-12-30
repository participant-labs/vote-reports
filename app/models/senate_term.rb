class SenateTerm < ActiveRecord::Base
  belongs_to :politician

  validates_presence_of :politician, :senate_class, :state

  def for
    "the #{politician.district} for #{UsState.name_from_abbrev(state)}"
  end
end
