class ReportSweeper < ActionController::Caching::Sweeper
  observe Report

  def after_create(report)
    expire_cache_for(report)
  end

  def after_update(report)
    expire_cache_for(report)
  end

  def after_destroy(report)
    expire_cache_for(report)
    if interest_group = report.interest_group
      expire_page interest_group_agenda_path(interest_group)
    elsif user = report.user
      expire_page user_report_agenda_path(user, report)
    end
  end

  def on_rescore(report)
    expire_fragment(/#{dom_id(score.report, :blank_score_embed)}/)
    expire_fragment(/#{dom_id(score.report, :embed)}/)
  end

  private

  def expire_cache_for(report)
    expire_fragment(:controller => 'site', :action => 'index')
    expire_fragment(dom_id(@report, :embed_header))
    expire_fragment(/#{dom_id(@report, :embed)}:.*/)
  end
end
