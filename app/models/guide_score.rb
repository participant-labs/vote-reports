class GuideScore
  include ActionView::Helpers::TextHelper
  include MongoMapper::Document
  include Score

  key :politician_id, Integer, :required => true, :numeric => true
  key :report_ids, Array, :required => true
  key :score, Float, :required => true
  key :evidence_ids, Array, :required => true
  key :evidence_description, String

  def initialize(*args)
    scores = args.first.delete(:scores)
    super
    build_scores(scores)
  end

  def politician
    Politician.find(self.politician_id)
  end

  def reports
    Report.find(self.report_ids)
  end

  def evidence
    evidence_ids.map do |report_score_id|
      GuideScore::Evidence.find_or_create_by_politician_id_and_report_score_id(politician_id, report_score_id)
    end
  end

  def to_s
    build_scores unless score
    letter_grade
  end

  private

  def evidence_count
    ReportScoreEvidence.count(:conditions => {:report_score_id => evidence_ids})
  end

  def build_evidence_description
    pluralize(evidence_count, ReportScoreEvidence.type_name('ReportScore'))
  end

  def build_scores(scores)
    return if self.score
    self.score = scores.sum {|s| s.score } / scores.size
    self.evidence_ids = scores.map(&:id)
    self.evidence_description = build_evidence_description
  end

end
