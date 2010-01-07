class BillCommitteeAction < ActiveRecord::Base
  belongs_to :bill
  belongs_to :committee_meeting

  validates_presence_of :bill, :committee_meeting, :action
end
