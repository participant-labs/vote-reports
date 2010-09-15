class Election < ActiveRecord::Base
  belongs_to :state, :class_name => 'UsState'
  has_many :stages, :class_name => 'ElectionStage'
  has_many :races, :through => :stages
end
