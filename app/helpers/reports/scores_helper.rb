module Reports::ScoresHelper
  def score_title(score)
    by = " by #{score.report.owner}" unless score.report.interest_group_id
    "#{score} for #{score.politician.full_name} on the '#{score.report.name}' report#{by}"
  end
end
