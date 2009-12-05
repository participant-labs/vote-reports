class User < ActiveRecord::Base
  is_gravtastic!
  has_friendly_id :username, :use_slug => true

  acts_as_authentic do |c|
    c.login_field = 'email'
  end

  has_many :reports

  validates_uniqueness_of :username

  def is_admin?
    false
  end
end
