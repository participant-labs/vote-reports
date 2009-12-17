class Amendment < ActiveRecord::Base
  belongs_to :bill
  has_many :rolls, :as => :subject, :dependent => :destroy

  validates_presence_of :bill, :title
  validates_uniqueness_of :gov_track_id
end
