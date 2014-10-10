class Issue < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :issue_causes, dependent: :destroy
  has_many :causes, through: :issue_causes

  validates_presence_of :title, :causes

  scope :random, -> { order('random()') }

  alias_attribute :name, :title
end
