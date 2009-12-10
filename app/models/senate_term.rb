class SenateTerm < ActiveRecord::Base
  belongs_to :politician
  belongs_to :congress

  validates_presence_of :politician, :congress
end
