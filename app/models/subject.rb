class Subject < ActiveRecord::Base
  has_many :bill_subjects
  has_many :bills, :through => :bill_subjects
end
