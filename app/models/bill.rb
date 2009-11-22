class Bill < ActiveRecord::Base
  class << self
    def find(id)
      bills = OpenCongress::OCBill.by_idents(Array(id))
      (bills.size == 1 ? new(bills.first) : bills.map {|bill| new(bill) })
    end

    def find_by_query(query)
      OpenCongress::OCBill.by_query(query).map do |bill|
        new(bill)
      end
    end
  end

  def initialize(ocbill)
    super(:title => ocbill.title, :bill_type => ocbill.bill_type_human, :opencongress_id => ocbill.ident)
  end

  def to_param
    opencongress_id
  end
end
