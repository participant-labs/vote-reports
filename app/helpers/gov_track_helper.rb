module GovTrackHelper
  def gov_track_map_url(object)
    "http://www.govtrack.us/embed/mapframe.xpd?" +
      if object.is_a?(UsState)
        {:state => object.abbreviation}
      elsif object.is_a?(District)
        if object.district == 0
          {:state => object.state.abbreviation}
        else
          {:state => object.state.abbreviation, :district => object.district}
        end
      else
        raise "Not gov-trackable: #{object.inspect}"
      end.to_param
  end
end
