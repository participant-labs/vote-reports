require 'delayed_job'

module Delayed
  class Job < ActiveRecord::Base
    def run_with_lock(max_run_time, worker_name)
      logger.info "* [JOB] acquiring lock on #{name}"
      unless lock_exclusively!(max_run_time, worker_name)
        # We did not get the lock, some other worker process must have
        logger.warn "* [JOB] failed to acquire exclusive lock for #{name}"
        return nil # no work done
      end

      begin
        runtime =  Benchmark.realtime do
          Timeout.timeout(max_run_time.to_i) { invoke_job }
          destroy
        end
        # TODO: warn if runtime > max_run_time ?
        logger.info "* [JOB] #{name} completed after %.4f" % runtime
        return true  # did work
      rescue Exception => e
        reschedule e.message, e.backtrace
        log_exception(e)
        raise  # work failed
      end
    end
  end
end
