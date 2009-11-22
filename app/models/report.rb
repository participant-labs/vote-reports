class Report < ActiveRecord::Base
  belongs_to :user
  has_many :bill_criteria
  has_many :bills, :through => :bill_criteria

  validates_presence_of :user_id
  validates_presence_of :name

  accepts_nested_attributes_for :bill_criteria
end
