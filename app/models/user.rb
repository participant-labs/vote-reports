class User < ActiveRecord::Base
  is_gravtastic!
  has_friendly_id :username, :use_slug => true

  acts_as_authentic

  has_many :reports

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

  def admin?
    false
  end

  private

  def before_merge_rpx_data(from_user, to_user)
    notify_exceptional "merging user #{from_user.to_param} into #{to_user.to_param}"
    to_user.reports << from_user.reports
    to_user.slugs << from_user.slugs
  end

  def after_merge_rpx_data(from_user, to_user)
    notify_exceptional "disabling login for #{from_user.to_param}"
    from_user.disable!
  end
end
