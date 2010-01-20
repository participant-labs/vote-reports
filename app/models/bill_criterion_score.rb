class BillCriterionScore
  DISCOUNTING_RATE = 0.07

  attr_reader :politician, :bill_criterion, :vote_scores
  delegate :bill, :to => :bill_criterion

  def initialize(args)
    @politician = args.fetch(:politician)
    @bill_criterion = args.fetch(:bill_criterion)
    @vote_scores = args.fetch(:votes).inject({}) do |scores, vote|
      scores[vote] = {
        :score => score_vote(vote),
        :base => base_for_vote(vote)
      }
      scores
    end
  end

  def votes
    @vote_scores.keys
  end

  def average_base
    @average_base ||= begin
      bases = @vote_scores.values.map {|score| score[:base] }
      bases.sum / bases.size
    end
  end

  def score
    scores = @vote_scores.values.map {|s| s[:score] * s[:base] }.sum
    bases = @vote_scores.values.map {|s| s[:base] }.sum
    scores / bases
  end

  def aligns?(vote)
    (@bill_criterion.support? && vote.aye?) || (@bill_criterion.oppose? && vote.nay?)
  end

  def contradicts?(vote)
    (@bill_criterion.support? && vote.nay?) || (@bill_criterion.oppose? && vote.aye?)
  end

  def score_vote(vote)
    if aligns?(vote)
      100.0
    elsif contradicts?(vote)
      0.0
    else
      50.0
    end
  end

  def base_for_vote(vote)
    (1 - DISCOUNTING_RATE) ** vote.roll.voted_at.to_date.years_until(Date.today)
  end
end