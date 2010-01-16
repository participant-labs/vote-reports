class Roll < ActiveRecord::Base
  has_many :votes, :dependent => :destroy
  belongs_to :subject, :polymorphic => true
  belongs_to :congress

  has_friendly_id :friendly_id

  named_scope :by_voted_at, :order => "voted_at DESC"

  class << self
    def find_by_friendly_id(friendly_id, options = {})
      if match = friendly_id.to_s.match(/(\d+)-([hs])(\d+)/)
        year, where, number = match.captures
        where = (where == 'h' ? 'house' : 'senate')
        find_by_where_and_year_and_number(where, year, number, options)
      else
        find_by_id(friendly_id, options = {})
      end
    end
  end
  
  def friendly_id
    "#{year}-#{where.first}#{number}" if year.present? && where.present? && number.present?
  end

  def opencongress_url
    "http://www.opencongress.org/vote/#{year}/#{where.first}/#{number}" if congress.current?
  end
end
