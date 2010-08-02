class BillCriterion < ActiveRecord::Base
  belongs_to :bill
  belongs_to :report
  has_many :evidence, :class_name => 'ReportScoreEvidence', :dependent => :destroy, :as => :criterion

  validates_presence_of :bill, :report
  validates_uniqueness_of :bill_id, :scope => "report_id"

  accepts_nested_attributes_for :bill

  named_scope :supported, :conditions => {:support => true}
  named_scope :opposed, :conditions => {:support => false}
  named_scope :by_introduced_on, :select => 'DISTINCT(bill_criteria.*), bills.introduced_on', :joins => :bill, :order => 'bills.introduced_on DESC'

  named_scope :active, :select => 'DISTINCT bill_criteria.*',
    :joins => {:bill => :rolls},
    :conditions => Roll.on_bill_passage.proxy_options[:conditions]

  class << self
    def inactive
      all - active
    end
  end

  after_save :rescore_report
  delegate :user_id, :to => :report

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

  def aligns?(vote)
    (support? && vote.aye?) || (oppose? && vote.nay?)
  end

  def contradicts?(vote)
    (support? && vote.nay?) || (oppose? && vote.aye?)
  end

  def events
    bill.passage_rolls.all(:include => {:votes => [{:politician => :state}, :roll]}).map(&:votes).flatten
  end

  def after_destroy
    report.rescore!
  end

  def event_score(vote)
    if aligns?(vote)
      100.0
    elsif contradicts?(vote)
      0.0
    else
      50.0
    end
  end

  private

  def rescore_report
    report.rescore! if new_record? || support_changed?
  end
end
