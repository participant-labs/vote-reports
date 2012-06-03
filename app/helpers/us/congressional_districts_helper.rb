module Us::CongressionalDistrictsHelper
  def congressional_district_name(district)
    [possesive(state_name(district.state)),
     link_to_unless_current("#{district.which.downcase} congressional district", congressional_district_path(district)),
    ].join(' '.html_safe)
  end
end
