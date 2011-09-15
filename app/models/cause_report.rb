class CauseReport < ActiveRecord::Base
  belongs_to :cause
  belongs_to :report

  validates_presence_of :cause, :report
  after_save :rescore_report
  after_destroy :rescore_report

  attr_writer :support
  def support
    !new_record? # if this is saved, then support is declared
  end

  delegate :scores, to: :report

  alias_method :events, :scores
  def event_score(event)
    event.score
  end

  private

  def rescore_report
    cause.report && cause.rescore!
  end
end
