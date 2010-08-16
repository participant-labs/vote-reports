class BillCriterionSweeper < ActionController::Caching::Sweeper
  observe BillCriterion

  def after_create(bill_criterion)
    expire_cache_for(bill_criterion)
  end

  def after_update(bill_criterion)
    expire_cache_for(bill_criterion)
  end

  def after_destroy(bill_criterion)
    expire_cache_for(bill_criterion)
  end

  private

  def expire_cache_for(bill_criterion)
    report = bill_criterion.report
    if interest_group = report.interest_group
      expire_page interest_group_agenda_path(interest_group)
    elsif user = report.user
      expire_page user_report_agenda_path(user, report)
    end
  end
end
