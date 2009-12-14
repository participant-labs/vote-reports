class Amendment < ActiveRecord::Base
  belongs_to :bill
  has_many :rolls, :as => :subject

  validates_presence_of :bill
  validates_uniqueness_of :gov_track_id
end
