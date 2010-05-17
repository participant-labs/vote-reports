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
end
