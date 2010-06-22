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
    # unlike #full_address, doesn't include the country
    zip = " #{geoloc.zip}" if geoloc.zip
    city = "#{geoloc.city}, " if geoloc.city
    "#{city}#{geoloc.state}#{zip}"
  end

  def current_location
    if session[:geo_location].try(:is_us?)
      geo_description(session[:geo_location])
    end
  end

  def sought_politicians
    @in_office = !params.has_key?(:in_office) || ['1', true].include?(params[:in_office])
    result =
      if !requested_location.nil?
        Politician.from(requested_location)
      elsif session[:geo_location].try(:is_us?)
        unless @dont_show_geo_address
          params[:representing] = geo_description(session[:geo_location])
        end
        Politician.from(session[:geo_location])
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
    elsif session[:geo_location].present?
      geo_description(session[:geo_location])
    end
  end

  def location_title(location)
    if location.is_a?(CongressionalDistrict)
      district_title(location)
    else
      state_title(location)
    end
  end
end
