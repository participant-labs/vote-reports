class Election < ActiveRecord::Base
  belongs_to :state, :class_name => 'UsState'
  belongs_to :office_type

  has_many :stages, :class_name => 'ElectionStage'
  has_many :races, :through => :stages
end
