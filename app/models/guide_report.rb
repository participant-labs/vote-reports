class GuideReport < ActiveRecord::Base
  belongs_to :guide
  belongs_to :report

  validates_presence_of :guide, :report
  after_save :rescore_report
  after_destroy :rescore_report

  delegate :scores, to: :report

  alias_method :events, :scores
  def event_score(event)
    event.score
  end

  private

  def rescore_report
    guide.rescore!
  end
end
