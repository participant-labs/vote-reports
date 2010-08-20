module GuidesHelper
  def score_for(scores, politician)
    scores.detect {|score| score.politician == politician }
  end
end
