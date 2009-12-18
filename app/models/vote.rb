class Vote < ActiveRecord::Base
  belongs_to :politician
  belongs_to :roll

  validates_uniqueness_of :roll_id, :scope => :politician_id
  validates_presence_of :politician, :roll
  validates_inclusion_of :vote, :in => %w[ + - P 0 ]
end
