class Roll < ActiveRecord::Base
  has_many :votes
  belongs_to :bill
  belongs_to :congress
end
