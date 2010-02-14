class SenateTerm < ActiveRecord::Base
  include PoliticianTermStuff
  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id

  validates_presence_of :senate_class, :state

  def title
    "Senator"
  end

  def place
    "for #{state.full_name}"
  end
end
