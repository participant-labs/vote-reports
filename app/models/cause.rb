class Cause < ActiveRecord::Base
  has_many :cause_reports
  has_many :reports, :through => :cause_reports

  has_friendly_id :name, :use_slug => true

  validates_presence_of :name, :description
end
