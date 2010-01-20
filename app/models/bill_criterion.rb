class BillCriterion < ActiveRecord::Base
  belongs_to :bill
  belongs_to :report

  validates_presence_of :bill, :report
  validates_uniqueness_of :bill_id, :scope => "report_id"

  accepts_nested_attributes_for :bill

  named_scope :active, :select => 'DISTINCT bill_criteria.*',
    :joins => {:bill => :rolls},
    :conditions => Roll.on_bill_passage.proxy_options[:conditions]

  def unvoted?
    !bill.rolls.on_bill_passage.exists?
  end

  def status
    if unvoted?
      bill.congress.current? ? "(not yet voted)" : "(unvoted)"
    end
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
    rolls = bill.rolls.on_bill_passage.all(:include => {:votes => {:politician => :state}})
    rolls.inject(Hash.new([])) do |scores, roll|
      roll.votes.each do |vote|
        scores[vote.politician] += [
          if aligns?(vote)
            100.0
          elsif contradicts?(vote)
            0.0
          else
            50.0
          end
        ]
      end
      scores
    end.inject({}) do |result, (politician, scores)|
      result[politician] = scores.sum / scores.size
      result
    end
  end
end
