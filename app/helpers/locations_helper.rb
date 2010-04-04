module LocationsHelper
  def zip_code?(location)
    (location =~ /^\s*\d{5}([-\s]*\d{4})?\s*$/).present?
  end

  def politicians_sought?
    requested_location.present?
  end

  def sought_politicians
    @in_office = !params.has_key?(:in_office) || ['1', true].include?(params[:in_office])
    if requested_location.present?
      Politician.from(requested_location)
    elsif session[:geo_location]
      params[:representing] = session[:geo_location].full_address
      Politician.from(session[:geo_location])
    else
      Politician
    end.in_office(@in_office)
  end

  def requested_location
    if params[:representing].present?
      params[:representing]
    elsif !params.has_key?(:representing) && session[:zip_code].present?
      session[:zip_code]
    end
  end
end
