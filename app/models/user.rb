class User < ActiveRecord::Base
  include Gravtastic
  gravtastic

  extend FriendlyId
  friendly_id :username, use: [:slugged, :history]
  alias_attribute :to_s, :username

  acts_as_authentic do |c|
    c.merge_validates_format_of_login_field_options with: /\A\w[\w\.+\-_@ ']+\z/
  end

  has_one :adminship
  has_one :moderatorship
  has_many :reports
  has_one :personal_report, -> { where(state: 'personal') }, class_name: 'Report'

  has_many :report_follows
  has_many :followed_reports, through: :report_follows, source: :report

  has_many :authentications

  validates_uniqueness_of :username, :email, case_sensitive: false
  validate :username_not_reserved

  state_machine initial: :active do
    event :disable do
      transition active: :disabled
    end
  end

  class << self
    def self.find_or_create_from_auth_hash(auth_hash)
      info = auth_hash['info']
      name = info['name'] || info['email']
      find_by_username_or_email(name)
    end

    def find_by_username_or_email(login)
      find_by_smart_case_login_field(login) || find_by_email(login)
    end
  end

  def avatar_url(size)
    if fake_email? && identifier = rpx_identifiers.find_by_provider_name('Facebook')
      type = size.to_i > 100 ? 'large' : 'square'
      prefix = 'http://www.facebook.com/profile.php?id='
      raise "Bad facebook id: #{identifier.identifier}" unless identifier.identifier.starts_with?(prefix)
      "http://graph.facebook.com/#{identifier.identifier.sub(prefix, '')}/picture?type=#{type}"
    else
      gravatar_url(size: size, default: "identicon")
    end
  end

  def role_symbols
    syms = [:user]
    syms << :admin if adminship
    syms << :moderator if moderatorship
    syms
  end

  def follows?(report)
    followed_reports.include?(report)
  end

  def rescore_personal_report
    (personal_report || build_personal_report(name: 'Personal Report', state: 'personal')).tap(&:save!).rescore!
  end

  def fake_email?
    email.to_s.ends_with?('+facebook@votereports.org')
  end

private

  def username_not_reserved
    if %w[new edit].include?(username.to_s.downcase)
      errors.add(:username, "is reserved")
    end
  end
end
