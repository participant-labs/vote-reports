class PoliticianTerm < ActiveRecord::Base
  abstract_class = true

  belongs_to :politician
  belongs_to :party
  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id
  validates_presence_of :politician

  named_scope :by_ended_on, :order => "ended_on DESC"
  named_scope :congressional, :conditions => {:type => ['RepresentativeTerm', 'SenateTerm']}

  class << self
    def latest(options = {})
      by_ended_on.first(options)
    end
  end

  def describe
    party = "; #{self.party}" if self.party
    "#{title} #{place}#{party}"
  end
end
