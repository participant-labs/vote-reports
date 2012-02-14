require 'delayed_job'

module Delayed
  class Job < ActiveRecord::Base
    has_many :report_delayed_jobs
    has_many :reports, through: :report_delayed_jobs

    scope :failing, where('delayed_jobs.last_error IS NOT NULL')
    scope :passing, where(last_error: nil)

    class << self
      alias :unlocked :passing
    end
  end
end
