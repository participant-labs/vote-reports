class Race < ActiveRecord::Base
  has_many :candidacies
  belongs_to :election_stage
  belongs_to :office

  named_scope :upcoming, :joins => :election_stage, :conditions => ['election_stages.voted_on > ?', Date.today]

  named_scope :for_districts, lambda {|districts|
    {
      :joins => [:office, {:election_stage => :election}],
      :conditions => [
        %{elections.state_id = ? AND (
            (offices.id = ? AND races.district = ?) OR
            (offices.id = ? AND races.district = ?) OR
            (offices.id IN(?) AND races.district = ?) OR
            (offices.id NOT IN(?))
        )},
        districts.first.state.id,
        Office.us_house,     districts.level('federal').first.name,
        Office.state_senate, districts.level('state_upper').first.name.to_i.to_s,
        Office.state_lower,  districts.level('state_lower').first.name.to_i.to_s,
        Office.districted
      ]
    }
  }

  named_scope :with_scores_from, lambda {|scores|
    {:joins => :candidacies, :conditions => {:candidacies => {:politician_id => scores.map(&:politician_id)}}}
  }

  delegate :election, :to => :election_stage
  delegate :state, :to => :election

  def where
    if district
      "the #{Integer(district).ordinalize rescue district} District of #{state.full_name}"
    else
      state.full_name
    end
  end
end
