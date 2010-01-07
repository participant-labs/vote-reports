class CommitteeMeeting < ActiveRecord::Base
  belongs_to :committee
  belongs_to :congress

  has_many :memberships, :class_name => 'CommitteeMembership'
  has_many :members, :through => :memberships, :source => :politician

  validates_presence_of :committee, :congress, :name
end
