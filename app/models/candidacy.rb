class Candidacy < ActiveRecord::Base
  belongs_to :politician
  belongs_to :race

  named_scope :valid, :conditions => ['status NOT IN(?)', ["Deceased", "Withdrawn", "Removed"]]
  named_scope :for_races, lambda {|races|
    {:conditions => {:race_id => races}}
  }

  class << self
    def upcoming_for_districts(districts)
      for_races(Race.for_districts(districts).upcoming)
    end
  end

  delegate :election_stage, :office, :to => :race
  delegate :election, :voted_on, :to => :election_stage
end
