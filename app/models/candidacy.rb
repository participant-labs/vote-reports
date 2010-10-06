class Candidacy < ActiveRecord::Base
  belongs_to :politician
  belongs_to :race

  named_scope :valid, :conditions => ['status NOT IN(?)', ["Deceased", "Withdrawn", "Removed"]]
  named_scope :for_races, lambda {|races|
    {:conditions => {:race_id => races}}
  }

  class << self
    def for_districts(districts)
      for_races(Race.for_districts(districts))
    end
  end
end
