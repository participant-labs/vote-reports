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

      private

      unless Rails.env.development? || Rails.env.production?
        def update_politician_state_and_title
          latest = politician.terms.latest
          return if latest.nil?
          state = politician.terms.latest(:joins => :state).try(:state)
          politician.update_attributes!(:state => state, :title => latest.title)
        end
      end
    end
  end
end