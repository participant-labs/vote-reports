class Report < ActiveRecord::Base
  belongs_to :user
  has_many :bill_criteria
  has_many :bills, :through => :bill_criteria

  validates_presence_of :user_id
  validates_presence_of :name

  accepts_nested_attributes_for :bill_criteria, :reject_if => proc {|attributes|
    attributes['support'] == '0' && attributes['oppose'] == '0'
  }

  named_scope :recent, {
    :limit => 10, :order => 'updated_at DESC'
  }
end
