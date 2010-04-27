class CommitteeMembership < ActiveRecord::Base
  belongs_to :committee_meeting
  belongs_to :politician

  validates_presence_of :committee_meeting, :politician
end
