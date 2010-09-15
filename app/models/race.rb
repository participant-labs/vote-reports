class Race < ActiveRecord::Base
  has_many :candidacies
  belongs_to :election_stage
  belongs_to :office
end
