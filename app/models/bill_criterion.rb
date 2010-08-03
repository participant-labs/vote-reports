class BillCriterion < ActiveRecord::Base
  include Criterion

  belongs_to :bill

  validates_presence_of :bill, :report
  validates_uniqueness_of :bill_id, :scope => "report_id"

  accepts_nested_attributes_for :bill

  named_scope :by_introduced_on, :select => 'DISTINCT(bill_criteria.*), bills.introduced_on', :joins => :bill, :order => 'bills.introduced_on DESC'

  named_scope :active, :select => 'DISTINCT bill_criteria.*',
    :joins => {:bill => :rolls},
    :conditions => Roll.on_bill_passage.proxy_options[:conditions]

  class << self
    def inactive
      all - active
    end
  end

  def unvoted?
    bill.passage_rolls.empty?
  end

  def events
    bill.passage_rolls.all(:include => {:votes => [{:politician => :state}, :roll]}).map(&:votes).flatten
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

end
