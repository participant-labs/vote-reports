class BillCriterion < ActiveRecord::Base
  belongs_to :bill
  belongs_to :report

  validates_presence_of :bill, :report
  validates_uniqueness_of :bill_id, :scope => "report_id"

  accepts_nested_attributes_for :bill

  named_scope :active, :select => 'DISTINCT bill_criteria.*',
    :joins => {:bill => :rolls},
    :conditions => Roll.on_bill_passage.proxy_options[:conditions]

  after_save :rescore_report

  def unvoted?
    bill.passage_rolls.empty?
  end

  def position
    support ? 'Support' : 'Oppose'
  end

  def support?
    support
  end

  def oppose?
    !support
  end

  def scores
    bill.passage_rolls.all(:include => {:votes => [{:politician => :state}, :roll]}).map(&:votes).flatten.group_by(&:politician).map do |politician, votes|
      BillCriterionScore.new(:bill_criterion => self, :votes => votes, :politician => politician)
    end
  end

  private

  def rescore_report
    report.rescore!
  end
end
