class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = 'email'
  end
  
  has_many :reports
  
  def is_admin?
    false
  end
end
