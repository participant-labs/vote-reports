class Date
  def years_until(stop)
    stop = stop.to_date
    (stop.year - year).to_f \
      + ((stop.month - month) / 12.0) \
      + ((stop.day - day) / 365.25)
  end
end
