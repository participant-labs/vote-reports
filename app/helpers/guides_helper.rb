module GuidesHelper
  def score_for(scores, politician)
    scores.detect {|score| score.politician_id == politician.id }
  end
end
