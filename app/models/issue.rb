class Issue < ActiveRecord::Base
  has_friendly_id :title, :use_slug => true

  has_many :issue_causes
  has_many :causes, :through => :issue_causes

  validates_presence_of :title, :causes
end
