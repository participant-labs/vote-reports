class ElectionStage < ActiveRecord::Base
  belongs_to :election
  has_many :races

  scope :future, -> { where(['voted_on >= ?', Date.today]) }
  scope :by_voted_on, -> { order('voted_on desc') }
end
