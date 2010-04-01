class Report
  class Scorer < Struct.new(:report_id)
    def perform
      @average_bases, @bases, @scores = {}, {}, {}
      report = Report.find(report_id)
      report.criteria_scores.group_by(&:politician_id).each_pair do |politician_id, criteria_scores|
        baseline = baseline_for(criteria_scores)

        scores = criteria_scores.map {|s| score_for(s) * average_base_for(s) / baseline }
        score = report.scores.build(:politician_id => politician_id, :score => scores.sum / scores.size)
        criteria_scores.each do |criterion_score|
          criterion_score.events.each do |event|
            score.evidence.build(:evidence => event, :criterion => criterion_score.criterion)
          end
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

    private

    def score_for(score)
      @scores[score] ||= begin
        scores = score.events.sum {|e| score.criterion.event_score(e) * base_for(e) }
        bases = score.events.sum {|e| base_for(e) }
        scores / bases
      end
    end

    def baseline_for(scores)
      scores.sum {|s| average_base_for(s) } / scores.size
    end

    def average_base_for(score)
      @average_bases[score] ||= score.events.sum {|event| base_for(event) } / score.events.size
    end

    DISCOUNTING_RATE = 0.07
    def base_for(event)
      @bases[event] ||= (1 - DISCOUNTING_RATE) ** event.event_date.years_until(Date.today)
    end
  end
end
