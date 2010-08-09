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
    if interest_group = bill_criterion.report.interest_group
      expire_page interest_group_agenda_path(interest_group)
    end
  end
end
