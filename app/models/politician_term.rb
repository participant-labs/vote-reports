module PoliticianTerm
  def self.included(base)
    base.class_eval do
      belongs_to :politician
      belongs_to :party
      validates_presence_of :politician

      named_scope :by_ended_on, :order => "ended_on DESC"

      unless Rails.env.development? || Rails.env.production?
        after_create :update_politician_state_and_title
      end

      class << self
        def latest(options = {})
          by_ended_on.first(options)
        end
      end

      def reelection_year
        if ended_on.month > 2
          ended_on.year
        else
          ended_on.year - 1
        end
      end

      private

      unless Rails.env.development? || Rails.env.production?
        def update_politician_state_and_title
          latest = politician.latest_term
          return if latest.nil?
          state = (
            politician.representative_terms.all(:joins => :congressional_district) +
            politician.senate_terms.all(:joins => :state)
          ).sort_by(&:ended_on).reverse.detect(&:state).try(:state)
          politician.update_attributes!(:state => state, :title => latest.title)
        end
      end
    end
  end
end