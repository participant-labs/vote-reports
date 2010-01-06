class BillCommitteeAction < ActiveRecord::Base
  belongs_to :bill
  belongs_to :committee

  validates_presence_of :bill, :committee, :action
end
