class Candidacy < ActiveRecord::Base
  INACTIVE_STATUSES = [
    "Won", "Lost", "Too Close To Call",
    "Deceased", "Withdrawn", "Removed"
  ]
  ACTIVE_STATUSES = ["Running"]

  belongs_to :politician
  belongs_to :race

  scope :valid, -> { where(status: ACTIVE_STATUSES) }
  scope :for_races, ->(races) {
    where(race_id: races)
  }

  class << self
    def upcoming_for_districts(districts)
      for_races(Race.for_districts(districts).upcoming)
    end
  end

  delegate :election_stage, :office, to: :race
  delegate :election, :voted_on, to: :election_stage
end
