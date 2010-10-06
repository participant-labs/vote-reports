class Race < ActiveRecord::Base
  has_many :candidacies
  belongs_to :election_stage
  belongs_to :office

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
end
