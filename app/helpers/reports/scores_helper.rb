module Reports::ScoresHelper
  def sort_scores(politicians, scores)
    politicians.map do |politician|
        [politician, score_for(scores, politician)]
    end.sort_by {|(pol, score)| score.try(:score) || -1 }.reverse
  end

  def score_title(score)
    on = if score.respond_to?(:report)
        by = " by #{score.report.owner}" unless score.report.interest_group_id
        " on '#{score.report.name}'#{by}"
      end
    "#{score} for #{score.politician.full_name}#{on}"
  end

  def score_class(score)
    score = score.to_s
    letter = score.first.downcase
    if score.ends_with?('+')
      "#{letter}_plus"
    elsif score.ends_with?('-')
      "#{letter}_minus"
    else
      letter
    end
  end

  def evidence_types(report)
    types = []
    score_criteria = report.score_criteria

    if score_criteria.detect {|c| c.is_a?(InterestGroupReport) }
      types << "interest group ratings"
    end
    if score_criteria.detect {|c| c.is_a?(BillCriterion) }
      types << "a specific legislative agenda"
    end
    types.join(' and ')
  end

  def interest_group_score_evidence_points(score)
    score.evidence.interest_group_ratings.group_by(&:subject).map do |(subject, scores)|
      notify_hoptoad("Multiple interest group ratings #{scores.inspect}") if scores.size > 1
      rating = scores.first.evidence
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
