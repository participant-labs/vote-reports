class CauseReport < ActiveRecord::Base
  belongs_to :cause
  belongs_to :report

  validates_presence_of :cause, :report

  attr_writer :support
  def support
    !new_record? # if this is saved, then support is declared
  end

  delegate :scores, :to => :report

  alias_method :events, :scores
  def event_score(event)
    event.score
  end
end
