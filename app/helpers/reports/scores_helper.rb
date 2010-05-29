module Reports::ScoresHelper
  def report_score_path(score)
    report = score.report
    if user = report.user
      user_report_score_path(user, report, score)
    elsif ig = report.interest_group
      interest_group_score_path(ig, score)
    elsif cause = report.cause
      cause_score_path(cause, score)
    else
      notify_hoptoad("Unknown score controller for #{score.inspect}")
      ''
    end
  end

  def score_title(score)
    by = " by #{score.report.owner}" unless score.report.interest_group_id
    "#{score} for #{score.politician.full_name} on '#{score.report.name}' #{by}"
  end

  def score_evidence_components(score)
    score.evidence.group_by(&:evidence_type).map do |(type, evidence)|
      pluralize(evidence.size, human_type_name(type))
    end
  end

  def score_evidence_points(score)
    score.evidence.group_by(&:subject).map do |(subject, subject_scores)|
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
      long_date = long_dates.delete(long_dates.rand)
      long_date_index = dates.index(long_date)
      dates[long_date_index] = long_date.split('-').last
    end
    dates
  end
end
