class Roll < ActiveRecord::Base
  has_many :votes, :dependent => :destroy
  belongs_to :subject, :polymorphic => true
  belongs_to :congress

  validates_presence_of :subject, :gov_track_id, :congress
  validates_uniqueness_of :gov_track_id

  named_scope :by_voted_at, :order => "voted_at DESC"
end
