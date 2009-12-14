class Roll < ActiveRecord::Base
  has_many :votes
  belongs_to :subject, :polymorphic => true
  belongs_to :congress

  validates_presence_of :subject, :opencongress_id, :congress
  validates_uniqueness_of :opencongress_id
end
