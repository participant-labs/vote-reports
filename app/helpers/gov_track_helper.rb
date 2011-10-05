module GovTrackHelper
  def gov_track_map_params(object)
    if object.is_a?(UsState)
      {state: object.abbreviation, bounds: object.bounds}
    elsif object.is_a?(CongressionalDistrict)
      if object.at_large?
        {state: object.state.abbreviation, bounds: object.state.bounds}
      else
        {state: object.state.abbreviation, bounds: object.state.bounds, district: object.district}
      end
    else
      raise "Not gov-trackable: #{object.inspect}"
    end.to_param
  end

  def gov_track_map_url(object)
    "http://www.govtrack.us/embed/mapframe.xpd?#{gov_track_map_params(object)}"
  end
end
