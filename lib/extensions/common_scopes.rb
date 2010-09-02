module CommonScopes
  def self.included(base)
    base.class_eval do
      named_scope :random, :order => 'random()'
    end
  end
end

class ActiveRecord::Base
  include CommonScopes
end
