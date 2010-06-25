class GuideScore
  include MongoMapper::Document

  key :politician_id, Integer, :required => true, :numeric => true
  key :report_ids, Array, :required => true
  key :score, Float, :required => true
  key :evidence_ids, Array, :required => true

  def initialize(*args)
    super
    build_scores
  end

  def politician
    Politician.find(self.politician_id)
  end

  def reports
    Report.scoped(:conditions => {:id => self.report_ids})
  end

  def evidence
    evidence_ids.map do |report_score_id|
      GuideScore::Evidence.find_or_create_by_politician_id_and_report_score_id(politician_id, report_score_id)
    end
  end

  def to_s
    build_scores unless score
    "#{score.round}%"
  end

  private

  def build_scores
    scores = politician.report_scores.for_reports(reports)
    self.score = scores.average(:score)
    self.evidence_ids = scores.map(&:id)
  end

end
