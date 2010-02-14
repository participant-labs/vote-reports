module PoliticianTermsHelper
  def term_description(term)
    party = "; #{term.party}" if term.party
    "#{term.title} #{term.place}#{party}"
  end
end