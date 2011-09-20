class Moderatorship < ActiveRecord::Base
  belongs_to :user
  belongs_to :created_by, class_name: 'User'

  validates_presence_of :user, :created_by
end
