module PoliticiansHelper
  def politician_title(politician)
    location = 
      if location = politician.location.try(:abbreviation)
        " (#{location})"
      end
    "#{politician_name(politician)}#{location}"
  end

  def politician_name(politician)
    "#{politician.short_title} #{politician.full_name}"
  end
end
