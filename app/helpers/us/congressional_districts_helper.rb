module Us::CongressionalDistrictsHelper
  def district_full_name(district)
    [link_to_unless_current("the #{district.which.downcase} congressional district", congressional_district_path(district)),
      state_name(district.state)
    ].join(' of ')
  end
  safe_helper :district_full_name

  def district_full_title_name(district)
    [link_to_unless_current("#{district.which} Congressional District", congressional_district_path(district)),
     state_name(district.state)
    ].join(' of ')
  end
  safe_helper :district_full_title_name
end
