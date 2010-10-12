module RacesHelper
  def race_location_link(race)
    if race.district
      state = link_to race.state.full_name, race.state
      begin
        district = Integer(race.district)
        district_name =
          if congressional_district = race.congressional_district
            link_to "#{district.ordinalize} Congressional District", congressional_district
          else
            "#{district.ordinalize} #{race.office.name} District"
          end
        "the #{district_name} of #{state}".html_safe
      rescue
        "the #{race.district} #{race.office.name} District of #{state}".html_safe
      end
    else
      link_to race.state.full_name, race.state
    end
  end
end
