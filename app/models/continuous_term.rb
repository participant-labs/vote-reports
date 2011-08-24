class ContinuousTerm
  include MongoMapper::Document

  key :politician_id, Integer, :required => true
  key :started_on, Date, :required => true
  key :ended_on, Date, :required => true
  key :url, String
  key :party, String
  key :location_type, String
  key :location_id, Integer

  def politician
    Politician.find(politician_id)
  end

  def representative_term
    terms.first['type'].constantize.find(terms.first['id'])
  end

  class << self
    def create_from_terms(politician, terms)
      create(
        :politician_id => politician.id,
        :started_on => terms.first.started_on.to_time,
        :ended_on => terms.last.ended_on.to_time,
        :party => terms.last.party.try(:name),
        :url => terms.last.url,
        :location_type => terms.last.location.class.name,
        :location_id => terms.last.location.try(:id),
        :title => terms.last.title,
        :terms => terms.map {|t| {:type => t.class.name, :id => t.id} }
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

    def regenerate!
      delete_all
      Politician.find_each do |politician|
        regenerate_for(politician)
      end
    end

    def related?(term, other)
      term.class == other.class && term.politician_id == other.politician_id \
        && term.party_id == other.party_id && term.location == other.location \
        && ((other.started_on - term.ended_on) < 6.months)
    end
  end
end
