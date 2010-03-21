class Committee < ActiveRecord::Base
  has_ancestry

  has_many :meetings, :class_name => 'CommitteeMeeting'
end
