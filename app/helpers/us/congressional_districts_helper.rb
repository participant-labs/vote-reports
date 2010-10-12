module Us::CongressionalDistrictsHelper
  def congressional_district_name(district)
    [link_to_unless_current("#{district.which} Congressional District", congressional_district_path(district)),
     state_name(district.state)
    ].join(' of ')
  end
  safe_helper :congressional_district_name
end
