module PoliticiansHelper
  def politician_title(politician)
    where = [politician.state.try(:abbreviation), politician.district].compact.join('-')
    state = " (#{where})" if where.present?
    "#{politician.short_title} #{politician.full_name}#{state}"
  end
end
