class Amendment < ActiveRecord::Base
  belongs_to :bill
  belongs_to :sponsor, :class_name => 'Politician'
  belongs_to :congress

  has_many :rolls, :as => :subject, :dependent => :destroy

  validates_presence_of :bill, :number, :chamber, :offered_on
  validates_uniqueness_of :number, :scope => [:chamber, :congress_id]
  validates_uniqueness_of :number, :scope => :bill_id
  validates_uniqueness_of :sequence, :scope => :bill_id, :allow_nil => true

  def title
    purpose || description
  end
end
