class Office < ActiveRecord::Base
  has_many :races
  belongs_to :office_type
end
