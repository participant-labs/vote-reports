class GuideScore < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include Score

  key :evidence_description, String

  belongs_to :guide
  belongs_to :politician
  has_many :evidence, class_name: 'GuideScoreEvidence'

  def to_s
    build_scores unless score
    letter_grade
  end

  def evidence_description
    pluralize(evidence_count, ReportScoreEvidence.type_name('ReportScore'))
  end

  private

  def build_scores
    return if score
    supported_scores = ReportScore.where(politician_id: politician_id, report_id: supported_report_ids)
    opposed_scores = ReportScore.where(politician_id: politician_id, report_id: opposed_report_ids)
    scores = supported_scores.map(&:score) + opposed_scores.map(&:opposition_score)
    self.score = scores.sum.to_f / scores.size
    self.evidence_count = ReportScoreEvidence.where(report_score_id: (supported_scores + opposed_scores)).count
    GuideScoreEvidence.import([:guide_score_id, :report_score_id, :support],
      supported_scores.map do |report_score|
        [id, report_score.id, true]
      end + opposed_scores.map do |report_score|
        [id, report_score.id, false]
      end
    )
  end
end
