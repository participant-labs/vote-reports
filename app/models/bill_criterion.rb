class BillCriterion < ActiveRecord::Base
  belongs_to :bill
  belongs_to :report

  validates_presence_of :bill, :report, :support
  validates_uniqueness_of :bill_id, :scope => "report_id"

  accepts_nested_attributes_for :bill

  def support?
    support
  end

  def oppose?
    !support
  end
end
