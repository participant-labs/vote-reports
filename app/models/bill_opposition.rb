class BillOpposition < ActiveRecord::Base
  belongs_to :politician
  belongs_to :bill
end
