require 'delayed_job'

module Delayed
  class Job < ActiveRecord::Base
    has_many :report_delayed_jobs
    has_many :reports, through: :report_delayed_jobs
  end
end