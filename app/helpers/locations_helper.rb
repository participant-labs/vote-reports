module LocationsHelper
  def mapy(object)
    if object.is_a?(GeoRuby::SimpleFeatures::Envelope)
      %{new google.maps.LatLngBounds(
         #{ mapy(object.lower_corner) },
         #{ mapy(object.upper_corner) }
      )}
    elsif object.respond_to?(:lat)
      "new google.maps.LatLng(#{ object.lat }, #{ object.lng })"
    elsif object.respond_to?(:y)
      "new google.maps.LatLng(#{ object.y }, #{ object.x })"
    else
      raise "Unrecognize map object #{object}"
    end.html_safe
  end

  def zip_code?(location)
    (location =~ /^\s*\d{5}([-\s]*\d{4})?\s*$/).present?
  end

  def geo_description(geoloc)
    return if geoloc.blank?
    return geoloc.to_s if geoloc.is_a?(Location)

    # unlike #full_address, doesn't include the country
    zip = " #{geoloc.zip}" if geoloc.zip
    city = "#{geoloc.city}, " if geoloc.city
    "#{city}#{geoloc.state}#{zip}"
  end

  def declared_geo_location
    session[:declared_geo_location] if session[:declared_geo_location].try(:is_us?)
  end

  def detected_geo_location
    session[:geo_location] if session[:geo_location].try(:is_us?)
  end

  def current_geo_location
    declared_geo_location || detected_geo_location
  end

  def current_location
    geo_description(current_geo_location)
  end

  def sought_politicians
    @in_office = !params.has_key?(:in_office) || ['1', true].include?(params[:in_office])
    result =
      if params.has_key?(:representing)
        Politician.from(params[:representing])
      elsif current_location
        unless @dont_show_geo_address
          params[:representing] = current_location
        end
        if session[:declared_geo_location].present?
          Politician.from_location(session[:declared_geo_location])
        else
          Politician.from_location(session[:geo_location])
        end
      else
        Politician
      end
    result = result.in_office if @in_office
    result
  end

  def shown_location
    requested_location || current_location
  end

  def requested_location
    if params.has_key?(:representing)
      params[:representing]
    else
      current_location
    end
  end

  def location_title(location)
    if location.is_a?(CongressionalDistrict)
      location.title
    else
      state_title(location)
    end
  end
end
