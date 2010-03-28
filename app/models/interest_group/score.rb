class InterestGroup::Score
  DISCOUNTING_RATE = 0.07

  attr_reader :politician_id, :criterion, :vote_scores

  def initialize(args)
    @politician_id = args.fetch(:politician_id)
    @criterion = args.fetch(:interest_group)
    @rating_scores = args.fetch(:ratings).inject({}) do |scores, rating|
      if rating.numeric_rating
        scores[rating] = {
          :score => rating.numeric_rating,
          :base => base_for_rating(rating)
        }
      end
      scores
    end
  end

  def average_base
    @average_base ||= begin
      bases = @rating_scores.values.map {|score| score[:base] }
      bases.sum / bases.size
    end
  end

  def score
    scores = @rating_scores.values.map {|s| s[:score] * s[:base] }.sum
    bases = @rating_scores.values.map {|s| s[:base] }.sum
    scores / bases
  end

  def base_for_rating(rating)
    (1 - DISCOUNTING_RATE) ** rating.interest_group_report.rated_on.years_until(Date.today)
  end

  def build_evidence_on(report_score)
    @rating_scores.keys.each do |rating|
      report_score.evidence.build(:evidence => rating, :criterion => @criterion)
    end
  end
end
