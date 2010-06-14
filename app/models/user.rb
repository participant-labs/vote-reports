class User < ActiveRecord::Base
  is_gravtastic!
  has_friendly_id :username, :use_slug => true
  alias_attribute :to_s, :username

  acts_as_authentic

  has_one :adminship
  has_one :moderatorship
  has_many :reports
  has_one :personal_report, :class_name => 'Report', :conditions => {:state => 'personal'}

  has_many :report_follows
  has_many :followed_reports, :through => :report_follows, :source => :report

  validates_uniqueness_of :username, :email, :case_sensitive => false
  validate :username_not_reserved

  state_machine :initial => :active do
    event :disable do
      transition :active => :disabled
    end
  end

  class << self
    def find_by_username_or_email(login)
      find_by_smart_case_login_field(login) || find_by_email(login)
    end
  end

  def role_symbols
    syms = [:user]
    syms << :admin if adminship
    syms << :moderator if moderatorship
    syms
  end

  def admin?
    role_symbols.include?(:admin)
  end

  def follows?(report)
    followed_reports.include?(report)
  end

private

  def username_not_reserved
    if %w[new edit].include?(username.to_s.downcase)
      errors.add(:username, "is reserved")
    end
  end
end
