module PoliticianTermsHelper
  def term_description(term)
    party = "; #{term.party}" if term.party
    "#{term.title} #{term_place(term)}#{party}"
  end

  def term_place(term)
    case term
    when PresidentialTerm
      "of these United States"
    when RepresentativeTerm
      "for #{term.district.full_name}"
    when SenateTerm
      "for #{term.state.full_name}"
    else
      notify_exceptional("Unrecognized term #{term.inspect}")
      ''
    end
  end
end