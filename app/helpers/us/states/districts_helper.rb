module Us::States::DistrictsHelper
  def district_full_name(district)
    [link_to_unless_current("the #{district.which.try(:downcase)} congressional district", district_path(district)),
      state_full_name(district.state)
    ].join(' of ')
  end
  safe_helper :district_full_name

  def district_full_title_name(district)
    [link_to_unless_current("The #{district.which} Congressional District", district_path(district)),
     state_full_name(district.state)
    ].join(' of ')
  end
  safe_helper :district_full_title_name

  def district_title(district)
    "The #{district.which} Congressional District of #{district.state.full_name}"
  end
end
