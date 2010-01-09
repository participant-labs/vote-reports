class PoliticianTerm < ActiveRecord::Base
  abstract_class = true

  belongs_to :politician
  belongs_to :party
  validates_presence_of :politician
end
