class GuideScore::Evidence
  include MongoMapper::Document

  key :politician_id, Integer, :required => true
  key :report_score_id, Integer, :required => true

  def evidence_type
    'ReportScore'
  end

  def evidence
    ReportScore.find(report_score_id)
  end

  def public_evidence_count
    evidence.evidence.count
  end

  def report
    evidence.report
  end
  alias_method :subject, :report
end
