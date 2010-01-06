class CommitteeName < ActiveRecord::Base
  belongs_to :committee
  belongs_to :congress

  validates_presence_of :committee, :congress, :name
end
