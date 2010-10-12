module RacesHelper
  def race_location_link(race)
    if congressional_district = race.congressional_district
      congressional_district_name(congressional_district)
    elsif race.district_name
      district_description =
        if district = race.district
          district_name(district)
        else
          "#{race.district_ordinal_name} #{race.office.name} District"
        end
      "the #{district_description} of #{state_name(race.state)}".html_safe
    else
      state_name(race.state)
    end
  end
end
