class ContinuousTerm < ActiveRecord::Base
  belongs_to :politician
  belongs_to :example_term, polymorphic: true

  class << self
    def create_from_terms(politician, terms)
      politician.continuous_term_records.create!(
        started_on: terms.first.started_on,
        ended_on: terms.last.ended_on,
        example_term: terms.last,
        terms_count: terms.size
      )
    end

    def regenerate_for(politician)
      terms = politician.terms
      return if terms.blank?

      current_terms = [terms.pop]
      while terms.present?
        if related?(current_terms.last, terms.last)
          current_terms << terms.pop
        else
          create_from_terms(politician, current_terms)
          current_terms = [terms.pop]
        end
      end
      create_from_terms(politician, current_terms)
    end

    def related?(term, other)
      term.class == other.class && term.politician_id == other.politician_id \
        && term.party_id == other.party_id && term.location == other.location \
        && ((other.started_on - term.ended_on) < 6.months)
    end
  end

  delegate :party, :title, to: :example_term
end
