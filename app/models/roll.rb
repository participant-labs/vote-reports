class Roll < ActiveRecord::Base
  has_many :votes, :dependent => :destroy
  belongs_to :subject, :polymorphic => true
  belongs_to :congress

  named_scope :by_voted_at, :order => "voted_at DESC"
end
