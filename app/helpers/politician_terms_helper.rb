module PoliticianTermsHelper
  def term_description(term)
    party = "; #{term.party}" if term.party
    "#{term.title} #{term_place(term)}#{party}".html_safe
  end

  def term_place(term)
    term = term.example_term if term.is_a?(ContinuousTerm)
    case term
    when PresidentialTerm
      "of these United States"
    when RepresentativeTerm
      "for #{congressional_district_name(term.congressional_district)}"
    when SenateTerm
      "for #{state_name(term.state)}"
    else
      Airbrake.notify(RuntimeError.new("Unrecognized term #{term.inspect}"))
      ''
    end.html_safe
  end
end
