class BillSubject < ActiveRecord::Base
  belongs_to :bill
  belongs_to :term
end
