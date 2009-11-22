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
    self.support = value
  end

  validates_presence_of :bill, :report
  
  accepts_nested_attributes_for :bill
end