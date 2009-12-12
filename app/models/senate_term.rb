class SenateTerm < ActiveRecord::Base
  belongs_to :politician
  belongs_to :congress

  validates_presence_of :politician, :congress

  def for
    "the #{politician.district} for #{UsState.name_from_abbrev(state)}"
  end
end
