module Reports::ScoresHelper
  def score_title(score)
    on = if score.respond_to?(:report)
        by = " by #{score.report.owner}" unless score.report.interest_group_id
        " on '#{score.report.name}'#{by}"
      end
    "#{score} for #{score.politician.full_name}#{on}"
  end

  def score_evidence_description(score)
    evidence_by_type = score.evidence.group_by(&:evidence_type)
    evidence_by_type.keys.sort.map do |type|
      evidence = evidence_by_type.fetch(type)
      name = human_type_name(type)
      pluralize(evidence.size, name)
    end.to_sentence
  end

  def evidence_types(report)
    types = []
    score_criteria = report.score_criteria
    if score_criteria.detect {|c| c.is_a?(InterestGroupReport) }
      types << link_to("historical interest group ratings", "#historical_ratings")
    end
    if score_criteria.detect {|c| c.is_a?(BillCriterion) }
      types << link_to("a specific legislative agenda", "#legislative_agenda")
    end
    types.join(' and ').html_safe
  end

  def interest_group_score_evidence_points(score)
    score.evidence.interest_group_ratings.group_by(&:subject).map do |(subject, subject_scores)|
      notify_hoptoad("Multiple interest group ratings #{subject_scores.inspect}") if subject_scores.size > 1
      rating = subject_scores.first.evidence
      tooltip = content_tag :dl, :class => 'chart_tooltip' do
        content_tag(:dt, "In #{subject.timespan}: #{rating.numeric_rating.round}%") \
         + content_tag(:dd, rating.description)
      end
      {:x => subject.timespan.to_s, :y => rating.numeric_rating, :tooltip => tooltip, :vote_smart_url => subject.vote_smart_url}
    end.sort_by {|p| p[:x] }
  end

  def pare_down_score_dates(dates)
    goal_size = 35
    return dates if dates.join.size <= goal_size

    long_dates = dates.select {|d| d.include?('-') }
    while dates.join.size > goal_size && long_dates.present?
      long_date = long_dates.delete(long_dates.random_element)
      long_date_index = dates.index(long_date)
      dates[long_date_index] = long_date.split('-').last
    end
    dates
  end
end
