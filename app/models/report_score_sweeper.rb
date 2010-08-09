class ReportScoreSweeper < ActionController::Caching::Sweeper
  observe ReportScore

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
    %w[small medium large].each do |headshot_style|
      expire_fragment(['politician', dom_id(score), headshot_style].join(':'))
    end
    expire_fragment(dom_id(score))
    expire_fragment(dom_id(score, 'evidence_summary'))
    expire_fragment(dom_id(score, 'interest_group_ratings'))
    expire_fragment(dom_id(score, 'evidence'))
  end
end
