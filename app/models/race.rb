class Race < ActiveRecord::Base
  has_many :candidacies
  belongs_to :election_stage
  belongs_to :office
  belongs_to :district

  before_create :populate_race_reference

  scope :upcoming, -> {
    joins(:election_stage).where(['election_stages.voted_on >= ?', Date.today])
  }

  scope :for_districts, ->(districts) {
    joins([:office, {election_stage: :election}]).where([
      %{elections.state_id = ? AND (
          (offices.id IN(?) AND races.district_name IN(?)) OR
          (offices.id IN(?) AND races.district_name IN(?)) OR
          (offices.id IN(?) AND races.district_name IN(?)) OR
          (offices.id NOT IN(?))
      )},
      districts.first.state.id,
      Office.us_house,     districts.level('federal').map {|d| d.name =~ /^\d*$/ ? d.name.to_i.to_s : d.name },
      Office.state_senate, districts.level('state_upper').map {|d| d.name =~ /^\d*$/ ? d.name.to_i.to_s : d.name },
      Office.state_lower,  districts.level('state_lower').map {|d| d.name =~ /^\d*$/ ? d.name.to_i.to_s : d.name },
      Office.districted
    ])
  }

  scope :with_scores_from, ->(scores) {
    joins(:candidacies).where(candidacies: {politician_id: scores.map(&:politician_id)})
  }

  scope :state_lower, -> { joins(:office).where(offices: {name: ['State House', 'State Assembly']}) }
  scope :state_upper, -> { joins(:office).where(offices: {name: 'State Senate'}) }
  scope :federal, -> { joins(:office).where(offices: {name: 'U.S. House'}) }

  delegate :election, to: :election_stage
  delegate :state, to: :election

  def district_ordinal_name
    District.ordinal_name(district_name)
  end

  def congressional_district
    if office.name == 'U.S. House'
      state.congressional_districts.find_by_district_number(district_name.to_i)
    end
  end

  def populate_race_reference
    level =
      case office.name
      when 'U.S. House'
        'federal'
      when 'State House', 'State Assembly'
        'state_lower'
      when 'State Senate'
        'state_upper'
      else
        return
      end
    district = state.districts.send(level).with_name(district_name).first
    self.district_id = district.id if district
  end
end
