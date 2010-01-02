class BillTitle < ActiveRecord::Base
  belongs_to :bill

  validates_presence_of :bill, :title, :title_type, :as
end
