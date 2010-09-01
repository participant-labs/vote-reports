module PoliticiansHelper
  def politician_title(politician)
    location = 
      if location = politician.location_abbreviation
        " (#{location})"
      end
    "#{politician_name(politician)}#{location}"
  end

  def politician_name(politician)
    "#{politician.short_title} #{politician.full_name}"
  end

  def politician_last_name(politician)
    "#{politician.short_title} #{politician.last_name}"
  end
end
