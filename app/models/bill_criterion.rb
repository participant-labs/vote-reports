class BillCriterion < ActiveRecord::Base
  belongs_to :bill
  belongs_to :report

  validates_presence_of :bill, :report
  validates_uniqueness_of :bill_id, :scope => "report_id"

  accepts_nested_attributes_for :bill

  def unvoted?
    !bill.rolls.on_passage.exists?
  end

  def support?
    support
  end

  def oppose?
    !support
  end

  def aligns?(vote)
    (support? && vote.aye?) || (oppose? && vote.nay?)
  end

  def contradicts?(vote)
    (support? && vote.nay?) || (oppose? && vote.aye?)
  end

  def score
    rolls = bill.rolls.on_passage
    roll_count = rolls.count
    rolls.inject(Hash.new(0.0)) do |scores, roll|
      roll.votes.each do |vote|
        scores[vote.politician] +=
          if aligns?(vote)
            1.0
          elsif contradicts?(vote)
            -1.0
          else
            0.0
          end / roll_count
      end
      scores
    end
  end
end
