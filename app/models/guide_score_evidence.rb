class GuideScoreEvidence < ActiveRecord::Base
  belongs_to :guide_score
  belongs_to :report_score

  delegate :report, :report_id, to: :report_score
  alias_method :subject, :report

  def evidence_type
    'ReportScore'
  end

  def evidence
    if support?
      report_score
    else
      Opposed.new(report_score)
    end
  end

  def public_evidence_count
    report_score.evidence.count
  end
end
