class SenateTerm < ActiveRecord::Base
  include PoliticianTerm
  belongs_to :state, class_name: 'UsState', foreign_key: :us_state_id

  validates_presence_of :senate_class, :state

  def title
    "Senator"
  end

  alias_attribute :location, :state
end
