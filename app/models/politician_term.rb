class PoliticianTerm < ActiveRecord::Base
  abstract_class = true

  belongs_to :politician
  belongs_to :party
  validates_presence_of :politician

  named_scope :by_ended_on, :order => "ended_on DESC"
  named_scope :congressional, :conditions => {:type => ['RepresentativeTerm', 'SenateTerm']}

  class << self
    def latest
      by_ended_on.first
    end
  end
end
