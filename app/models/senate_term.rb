class SenateTerm < ActiveRecord::Base
  include Term

  validates_presence_of :senate_class, :state

  def for
    "the #{politician.district} for #{UsState.name_from_abbrev(state)}"
  end
end
