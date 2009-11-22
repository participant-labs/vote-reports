class Bill < ActiveRecord::Base
  class << self
    def fetch(id)
      Cachy.cache(id, :expires_in => 1.day) do
        find_by_opencongress_id(id) ||
          begin
            ids = Array(id)
            bills = OpenCongress::OCBill.by_idents(ids)
            (ids.size == 1 ? find_or_create(bills.first) : bills.map {|bill| find_or_create(bill) })
          end
      end
    end

    def fetch_by_query(query)
      Cachy.cache(query, :expires_in => 1.day, :hash_key => true) do
        OpenCongress::OCBill.by_query(query).map do |bill|
          find_or_create(bill)
        end
      end
    end

    def find_or_create(bill)
      find_by_opencongress_id(bill.ident) || create(bill)
    end
  end

  def initialize(ocbill)
    super(:title => ocbill.title, :bill_type => ocbill.bill_type_human, :opencongress_id => ocbill.ident)
  end
  
  def bill_type= bill_type
    self['bill_type']= bill_type.gsub('.',' ').gsub('H Res','HR').gsub('H R','HR')
  end

  def title_with_number
    "#{bill_type}: #{title}"
  end

  def to_param
    opencongress_id
  end

  def opencongress_url
    "http://www.opencongress.org/bill/#{opencongress_id}/show"
  end

  has_many :bill_criteria, :dependent => :destroy

  validates_uniqueness_of :opencongress_id
end
