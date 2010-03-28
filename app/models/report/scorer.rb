class Report
  class Scorer < Struct.new(:report_id)
    def perform
      report = Report.find_by_id(report_id) \
        || raise("Tried to score missing report #{report_id}")
      report.criteria_scores.group_by(&:politician).each_pair do |politician, criteria_scores|
        baseline = criteria_scores.map(&:average_base)
        baseline = baseline.sum / baseline.size

        scores = criteria_scores.map {|s| s.score * s.average_base / baseline }
        score = report.scores.build(:politician => politician, :score => scores.sum / scores.size)
        criteria_scores.each do |criterion_score|
          criterion_score.build_evidence_on(score)
        end
      end
      ActiveRecord::Base.transaction do
        ReportScore.delete_all(:report_id => report)
        if report.scores.empty? && report.can_unpublish?
          report.unpublish
        else
          report.save!
        end
      end
    rescue => e
      unless Rails.env.production?
        p e
        puts e.backtrace
      end
      raise
    end
  end
end
