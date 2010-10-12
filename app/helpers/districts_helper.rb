module DistrictsHelper
  def district_name(district)
    case district.level.level
    when 'state_lower'
      link_to_unless_current district.title, state_lower_district_path(district.state, district)
    when 'state_upper'
      link_to_unless_current district.title, state_upper_district_path(district.state, district)
    when 'federal'
      congressional_district_name(district.congressional_district)
    else
      raise "not a district we can show #{district.inspect}"
    end
  end

  def full_district_name(district)
    "#{district_name(district)} of #{state_name(district.state)}".html_safe
  end
end
