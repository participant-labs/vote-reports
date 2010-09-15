class ElectionStage < ActiveRecord::Base
  belongs_to :election
  has_many :races
end