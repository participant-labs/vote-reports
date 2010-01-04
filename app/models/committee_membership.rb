class CommitteeMembership < ActiveRecord::Base
  belongs_to :committee
  belongs_to :politician
  belongs_to :congress

  validates_presence_of :committee, :politician, :congress
end
