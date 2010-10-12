module RacesHelper
  def race_location_link(race)
    if race.district
      "the #{Integer(district).ordinalize rescue district} District of #{link_to race.state.full_name, race.state}".html_safe
    else
      link_to race.state.full_name, race.state
    end
  end
end
