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

  def score_vote(vote)
    if @bill_criterion.aligns?(vote)
      100.0
    elsif @bill_criterion.contradicts?(vote)
      0.0
    else
      50.0
    end
  end

  def base_for_vote(vote)
    (1 - DISCOUNTING_RATE) ** vote.roll.voted_at.to_date.years_until(Date.today)
  end

  def build_evidence_on(report_score)
    votes.each do |vote|
      report_score.evidence.build(:vote => vote, :bill_criterion => bill_criterion)
    end
  end
end