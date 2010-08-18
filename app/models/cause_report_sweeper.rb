class CauseReportSweeper < ActionController::Caching::Sweeper
  observe CauseReport

  def after_create(cause_report)
    expire_cache_for(cause_report)
  end

  def after_update(cause_report)
    expire_cache_for(cause_report)
  end

  def after_destroy(cause_report)
    expire_cache_for(cause_report)
  end

  private

  def expire_cache_for(cause_report)
  end
end
