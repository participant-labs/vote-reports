class AmendmentCriterion < ActiveRecord::Base
  include Criterion

  belongs_to :amendment
  alias_method :subject, :amendment

  validates_presence_of :amendment, :report
  validates_uniqueness_of :amendment_id, :scope => "report_id"

  accepts_nested_attributes_for :amendment

  named_scope :by_offered_on, :select => 'DISTINCT(amendment_criteria.*), amendments.offered_on', :joins => :amendment, :order => 'amendments.offered_on DESC'
  named_scope :with_votes, :select => 'DISTINCT amendment_criteria.*', :joins => {:amendment => :rolls}


  class << self
    def active
      with_votes
    end

    def inactive
      all - active
    end
  end

  def unvoted?
    amendment.passage_rolls.empty?
  end

  def events
    amendment.passage_rolls.all(:include => {:votes => [{:politician => :state}, :roll]}).map(&:votes).flatten
  end

  def event_score(vote)
    if aligns?(vote)
      100.0
    elsif contradicts?(vote)
      0.0
    else
      50.0
    end
  end
end