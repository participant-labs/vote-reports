class CauseReport < ActiveRecord::Base
  belongs_to :cause
  belongs_to :report

  validates_presence_of :cause, :report

  attr_accessor :support

  delegate :scores, :to => :report
  alias_method :events, :scores
  def event_score(event)
    event.score
  end
end
