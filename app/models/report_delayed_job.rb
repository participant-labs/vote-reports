class ReportDelayedJob < ActiveRecord::Base
  belongs_to :report
  belongs_to :delayed_job, :class_name => '::Delayed::Job'
end
