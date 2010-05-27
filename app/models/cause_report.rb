class CauseReport < ActiveRecord::Base
  belongs_to :cause
  belongs_to :report

  validates_presence_of :cause, :report
end
