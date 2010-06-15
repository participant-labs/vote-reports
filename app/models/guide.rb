class Guide < ActiveRecord::Base
  belongs_to :report
  belongs_to :user
  belongs_to :zip_code
  belongs_to :district

  has_many :guide_reports
  has_many :reports, :through => :guide_report
end
