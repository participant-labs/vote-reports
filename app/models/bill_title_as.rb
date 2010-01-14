class BillTitleAs < ActiveRecord::Base
  has_many :titles, :class_name => 'BillTitle'

  def to_s
    as
  end
end
