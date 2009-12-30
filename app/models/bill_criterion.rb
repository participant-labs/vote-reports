class BillCriterion < ActiveRecord::Base
  belongs_to :bill
  belongs_to :report

  def oppose
    if new_record?
      !support.nil? && !support
    else
      !support
    end
  end

  def oppose=(value)
    self[:support] = false if value == '1'
  end
  
  def support=(value)
    self[:support] = true if value == '1'
  end

  validates_presence_of :bill, :report, :support
  validates_uniqueness_of :bill_id, :scope => "report_id"

  accepts_nested_attributes_for :bill
end
