module PoliticiansHelper
  def politician_title(politician)
    state = " (#{politician.state.abbreviation})" if politician.state
    "#{politician.short_title} #{politician.full_name}#{state}"
  end
end
