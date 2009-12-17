class Bill < ActiveRecord::Base
  named_scope :recent, :limit => 25, :order => 'created_at DESC'

  has_friendly_id :opencongress_id
  has_many :rolls, :as => :subject, :dependent => :destroy
  has_many :amendments, :dependent => :destroy
  belongs_to :congress
  belongs_to :sponsor, :class_name => 'Politician'

  validates_presence_of :bill_type, :congress, :sponsor
  validates_uniqueness_of :gov_track_id

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
      find_by_opencongress_id(bill.ident) || create(:title => bill.title, :bill_type => bill.bill_type_human, :opencongress_id => bill.ident)
    end
  end

  def bill_type
    self['bill_type'].gsub('.',' ').gsub('H Res','HR').gsub('H R','HR')
  end

  def title_with_number
    "#{bill_type}: #{title}"
  end

  def opencongress_url
    "http://www.opencongress.org/bill/#{opencongress_id}/show"
  end

  has_many :bill_criteria, :dependent => :destroy
  has_many :votes
  has_many :politicians, :through => :votes do
    def supporting
      scoped(:conditions => "votes.vote = true")
    end
    def opposing
      scoped(:conditions => "votes.vote = false")
    end
  end

  validates_uniqueness_of :opencongress_id, :allow_nil => true
end
