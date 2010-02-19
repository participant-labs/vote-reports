class Report
  class Scorer < Struct.new(:report_id)
    def perform
      report = Report.find_by_id(report_id) || begin
        notify_exceptional("Tried to score missing report #{report_id}")
        return nil
      end
      report.bill_criteria.active.map(&:scores).flatten.group_by(&:politician).each_pair do |politician, bill_scores|
        bill_baseline = bill_scores.map(&:average_base)
        bill_baseline = bill_baseline.sum / bill_baseline.size

        scores = bill_scores.map {|s| s.score * s.average_base / bill_baseline }
        score = report.scores.build(:politician => politician, :score => scores.sum / scores.size)
        bill_scores.each do |bill_score|
          bill_score.votes.each do |vote|
            score.evidence.build(:vote => vote, :bill_criterion => bill_score.bill_criterion)
          end
        end
      end
      ActiveRecord::Base.transaction do
        ReportScore.delete_all(:report_id => report)
        report.save!
        report.unpublish if report.scores.empty? && report.can_unpublish?
      end
    end
  end
end