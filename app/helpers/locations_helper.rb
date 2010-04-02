module LocationsHelper
  def zip_code?(location)
    (location =~ /^\s*\d{5}([-\s]*\d{4})?\s*$/).present?
  end

  def politicians_sought?
    params[:representing].present? || session[:zip_code].present?
  end

  def sought_politicians
    @in_office = !params.has_key?(:in_office) || params[:in_office]
    if params.has_key?(:representing)
      Politician.from(params[:representing])
    elsif session[:zip_code].present?
      Politician.from(session[:zip_code])
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
    elsif session[:zip_code].present?
      session[:zip_code]
    end
  end
end
