class Bill < DelegateClass(OpenCongress::OCBill)
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

  def to_param
    ident
  end
end
