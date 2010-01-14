class Roll < ActiveRecord::Base
  has_many :votes, :dependent => :destroy
  belongs_to :subject, :polymorphic => true
  belongs_to :congress

  # has_friendly_id :friendly_id

  named_scope :by_voted_at, :order => "voted_at DESC"

  # class << self
  #   def find_by_friendly_id(friendly_id, options = {})
  #     year, where, number = friendly_id.match(/(\d+)-([hs])(\d+)/).captures
  #     where = (where == 'h' ? 'house' : 'senate')
  #     find_by_where_and_year_and_number(where, year, number, options)
  #   end
  # end
  # 
  # def friendly_id
  #   "#{year}-#{where.first}#{number}" if year.present? && where.present? && number.present?
  # end
end
