class ReportSweeper < ActionController::Caching::Sweeper
  observe Report

  def after_create(report_score)
    expire_cache_for(report_score)
  end

  def after_update(report_score)
    expire_cache_for(report_score)
  end

  def after_destroy(report_score)
    expire_cache_for(report_score)
  end

  private

  def expire_cache_for(report_score)
    expire_fragment(:controller => 'site', :action => 'index')
  end
end
