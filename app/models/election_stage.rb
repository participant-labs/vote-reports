class ElectionStage < ActiveRecord::Base
  belongs_to :election
  has_many :races

  named_scope :future, :conditions => ['voted_on >= ?', Date.today]
  named_scope :by_voted_on, :order => 'voted_on desc'
end
