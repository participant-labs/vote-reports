class BillSubject < ActiveRecord::Base
  belongs_to :bill
  belongs_to :subject

  validates_presence_of :bill, :subject
end
