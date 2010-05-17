module Reports::ScoresHelper
  def score_title(score)
    by = " by #{score.report.owner}" unless score.report.interest_group_id
    "#{score} for #{score.politician.full_name} on '#{score.report.name}' #{by}"
  end
end
