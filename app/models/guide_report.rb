class GuideReport < ActiveRecord::Base
  belongs_to :guide
  belongs_to :report
end
