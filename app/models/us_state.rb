class UsState < ActiveRecord::Base
  FIPS_CODES = {
    "01" => "AL",
    "02" => "AK",
    "04" => "AZ",
    "05" => "AR",
    "06" => "CA",
    "08" => "CO",
    "09" => "CT",
    "10" => "DE",
    "11" => "DC",
    "12" => "FL",
    "13" => "GA",
    "15" => "HI",
    "16" => "ID",
    "17" => "IL",
    "18" => "IN",
    "19" => "IA",
    "20" => "KS",
    "21" => "KY",
    "22" => "LA",
    "23" => "ME",
    "24" => "MD",
    "25" => "MA",
    "26" => "MI",
    "27" => "MN",
    "28" => "MS",
    "29" => "MO",
    "30" => "MT",
    "31" => "NE",
    "32" => "NV",
    "33" => "NH",
    "34" => "NJ",
    "35" => "NM",
    "36" => "NY",
    "37" => "NC",
    "38" => "ND",
    "39" => "OH",
    "40" => "OK",
    "41" => "OR",
    "42" => "PA",
    "44" => "RI",
    "45" => "SC",
    "46" => "SD",
    "47" => "TN",
    "48" => "TX",
    "49" => "UT",
    "50" => "VT",
    "51" => "VA",
    "53" => "WA",
    "54" => "WV",
    "55" => "WI",
    "56" => "WY",
    "60" => "AS",
    "64" => "FM",
    "66" => "GU",
    "68" => "MH",
    "69" => "MP",
    "70" => "PW",
    "72" => "PR",
    "74" => "UM",
    "78" => "VI"
  }

  def unincorporated?
    state_type != 'state'
  end

  has_friendly_id :abbreviation

  has_many :districts
  has_many :elections, foreign_key: 'state_id'

  def races
    Race.where(elections: {state_id: self}).joins(election_stage: :election)
  end

  has_many :congressional_districts
  has_many :representative_terms, through: :congressional_districts
  def representatives
    Politician.representatives_from_state(self)
  end

  def representatives_in_office
    representatives.where(['politicians.current_office_type = ?', 'RepresentativeTerm'])
  end

  has_many :senate_terms
  has_many :senators, through: :senate_terms, source: :politician, uniq: true do
    def in_office
      where(['politicians.current_office_type = ?', 'SenateTerm'])
    end
  end

  def presidents
    Politician.presidents
  end
end
