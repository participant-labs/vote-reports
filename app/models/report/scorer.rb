class Report
  class Scorer
    attr_reader :report_id

    def initialize(report_id)
      raise "Bad report_id #{report_id}" unless Report.find_by_id(report_id)
      @report_id = report_id
      GuideScore.delete_all(:report_ids => report_id)
    end

    def perform
      require 'mongo_mapper'

      config = YAML.load_file(Rails.root.join('config', 'mongo.yml'))
      MongoMapper.setup(config, Rails.env, {
        :logger    => Rails.logger,
        :passenger => true,
      })
      MongoMapper.database = config[Rails.env]['database']

      rescue_and_reraise do
        require 'ar-extensions'
        require 'ar-extensions/import/postgresql'
        @bases = {}
        ActiveRecord::Base.transaction do
          report = Report.find(report_id)
          evidences = []
          ReportScore.destroy_all(:report_id => report.id)
          ReportSweeper.new.on_rescore(self)
          report.score_criteria.inject({}) do |criterion_events, criterion|
            # Collect up all important events by politician and criteria
            # e.g.
            #  criterion_events =
            #    politician -> bill criteria -> votes
            #    politician -> interest group reports -> ratings
            #
            criterion.events.each do |event|
              criterion_events[event.politician_id] ||= {}
              criterion_events[event.politician_id][criterion] ||= []
              criterion_events[event.politician_id][criterion] << event
            end
            criterion_events
          end.each_pair do |politician_id, criteria_events|
            score = report.scores.create!(:politician_id => politician_id, :score => report_score(criteria_events))

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
          ReportSubject.generate_for(report)
        end
      end
    end

    private

    def report_score(criteria_events)
      # Calculate scores for each criteria event (e.g. bill, ig report)
      criteria_scores = criteria_events.map do |(criterion, events)|
        {:score => criterion_score(criterion, events), :base => average_base_for(events)}
      end
      consolidate_score(criteria_scores)
    end

    def criterion_score(criterion, events)
      consolidate_score(events.map {|e| {:score => criterion.event_score(e), :base => base_for(e) } })
    end

    def consolidate_score(scores_and_bases)
      scores = scores_and_bases.sum {|score_and_base| score_and_base[:score] * score_and_base[:base]}
      scores / scores_and_bases.sum {|score_and_base| score_and_base[:base]}
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
