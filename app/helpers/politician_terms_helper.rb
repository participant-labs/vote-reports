module PoliticianTermsHelper
  def describe_term(term)
    party = "; #{term.party}" if term.party
    case term
    when RepresentativeTerm
      district = "the #{term.district == 0 ? 'at-large' : term.district.ordinalize} district of " if term.district
      "Representative for #{district}#{UsState.name_from_abbrev(term.state)}#{party}"
    when SenateTerm
      "Senator for #{UsState.name_from_abbrev(term.state)}#{party}"
    when PresidentialTerm
      "President of these United States#{party}"
    else
      raise "Unknown term #{term.inspect}"
    end
  end
  
end