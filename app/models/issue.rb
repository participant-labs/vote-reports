class Issue < ActiveRecord::Base
  has_friendly_id :title, :use_slug => true

  has_many :issue_causes, dependent: :destroy
  has_many :causes, through: :issue_causes

  validates_presence_of :title, :causes

  scope :random, order('random()')

  alias_attribute :name, :title
end
