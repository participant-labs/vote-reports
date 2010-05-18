module Reports::ScoresHelper
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
      tooltip = content_tag :dl do
        content_tag(:dt, "In #{subject.timespan}: #{rating.numeric_rating.round}%") \
         + content_tag(:dd, rating.description)
      end
      {:x => subject.timespan.to_s, :y => rating.numeric_rating, :tooltip => tooltip}
    end.sort_by {|p| p[:x] }
  end
end
