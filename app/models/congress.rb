class Congress < ActiveRecord::Base
  has_many :bills, :dependent => :destroy

  validates_uniqueness_of :meeting
end