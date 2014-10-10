class ReportFollow < ActiveRecord::Base
  belongs_to :report
  belongs_to :user

  after_create :rescore_personal_report
  after_destroy :rescore_personal_report

  validates_uniqueness_of :report_id, scope: :user_id

  delegate :scores, to: :report

  alias_method :events, :scores
  def event_score(event)
    event.score
  end

  private

  delegate :rescore_personal_report, to: :user
end
