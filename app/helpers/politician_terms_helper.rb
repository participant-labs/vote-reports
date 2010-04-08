module PoliticianTermsHelper
  def term_description(term)
    party = "; #{term.party}" if term.party
    "#{term.title} #{term_place(term)}#{party}"
  end
  safe_helper :term_description

  def term_place(term)
    case term
    when PresidentialTerm
      "of these United States"
    when RepresentativeTerm
      "for #{district_full_name(term.district)}"
    when SenateTerm
      "for #{state_full_name(term.state)}"
    else
      notify_exceptional("Unrecognized term #{term.inspect}")
      ''
    end
  end
  safe_helper :term_place
end