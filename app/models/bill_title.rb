class BillTitle < ActiveRecord::Base
  belongs_to :bill
  belongs_to :as, foreign_key: 'bill_title_as_id', class_name: 'BillTitleAs'

  validates_presence_of :bill, :title, :title_type

  default_scope joins: :as, order: "bill_title_as.sort_order, bill_titles.title_type DESC"

  def to_s
    title
  end
end
