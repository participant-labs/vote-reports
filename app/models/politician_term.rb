class PoliticianTerm < ActiveRecord::Base
  abstract_class = true

  belongs_to :politician
  belongs_to :party
  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id
  validates_presence_of :politician

  named_scope :by_ended_on, :order => "ended_on DESC"
  named_scope :congressional, :conditions => {:type => ['RepresentativeTerm', 'SenateTerm']}

  unless Rails.env.development?
    after_create :update_politician_state_and_title
  end

  class << self
    def latest(options = {})
      by_ended_on.first(options)
    end
  end

  private

  unless Rails.env.development?
    def update_politician_state_and_title
      latest = politician.terms.latest
      return if latest.nil?
      state = politician.terms.latest(:joins => :state).try(:state)
      politician.update_attributes!(:state => state, :title => latest.title)
    end
  end
end
