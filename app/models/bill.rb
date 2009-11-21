class Bill
  class << self
    def find(query)
      OpenCongress::OCBill.by_query(query)
    end
  end
end
