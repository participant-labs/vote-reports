class IssueCause < ActiveRecord::Base
  belongs_to :issue
  belongs_to :cause
end
