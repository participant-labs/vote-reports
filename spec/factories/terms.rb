FactoryGirl.define do
  factory :presidential_term do
    politician
    party
    started_on { 2.years.ago }
    ended_on { 2.years.from_now }
  end

  factory :representative_term do
    politician
    party
    congressional_district
    started_on { 1.years.ago }
    ended_on { 1.years.from_now }
  end

  factory :senate_term do
    politician
    party
    senate_class { [1, 2, 3].sample }
    state { UsState.all.sample }
    started_on { 3.years.ago }
    ended_on { 3.years.from_now }
  end
end


def politician_term_overrides(overrides, years)
  overrides.process(:party) do |party|
    party = nil if party.blank?
    party = Party.find_or_create_by(name: party) if party.is_a?(String)
    overrides[:party] = party
  end

  overrides.process(:state) do |state|
    overrides[:state] = us_state(state)
  end

  overrides.process(:name) do |name|
    overrides[:politician] = Politician.with_name(name).first
  end

  overrides.process(:in_office) do |in_office|
    if in_office == 'true'
      overrides[:started_on] = 1.year.ago
      overrides[:ended_on] = 1.year.ago + years.years
    else
      overrides[:started_on] = 14.years.ago
      overrides[:ended_on] = 14.years.ago + years.years
    end
  end
end
