class Report
  class Scorer < Struct.new(:report_id)
    def perform
      require 'ar-extensions'
      require 'ar-extensions/import/postgresql'
      @bases = {}
      ActiveRecord::Base.transaction do
        report = Report.find(report_id)
        evidences = []
        ReportScore.delete_all(:report_id => report)
        report.score_criteria.inject({}) do |criterion_events, criterion|
          criterion.events.each do |event|
            criterion_events[event.politician_id] ||= {}
            criterion_events[event.politician_id][criterion] ||= []
            criterion_events[event.politician_id][criterion] << event
          end
          criterion_events
        end.each_pair do |politician_id, criteria_events|
          baseline = average_base_for(criteria_events.values.flatten)

          scores = criteria_events.map do |criterion, events|
            score_for(criterion, events) * average_base_for(events) / baseline
          end
          score = report.scores.create!(:politician_id => politician_id, :score => scores.sum / scores.size)
          criteria_events.each_pair do |criterion, events|
            evidences += events.map do |event|
              [score.id, criterion.class.name, criterion.id, event.class.name, event.id]
            end
          end
        end
        unless evidences.blank?
          ReportScoreEvidence.import_without_validations_or_callbacks(
            [:report_score_id, :criterion_type, :criterion_id, :evidence_type, :evidence_id],
            evidences)
        end
        if report.scores.empty? && report.can_unlist?
          report.unlist
        else
          report.save!
        end
        ReportSubject.regenerate_for(report)
      end
    rescue => e
      unless Rails.env.production?
        p e
        puts e.backtrace
      end
      raise
    end

    private

    def score_for(criterion, events)
      scores = events.sum {|e| criterion.event_score(e) * base_for(e) }
      scores / events.sum {|e| base_for(e) }
    end

    def average_base_for(events)
      events.sum {|e| base_for(e) } / events.size
    end

    DISCOUNTING_RATE = 0.07
    def base_for(event)
      @bases[event] ||= (1 - DISCOUNTING_RATE) ** event.event_date.years_until(Date.today)
    end
  end
end
