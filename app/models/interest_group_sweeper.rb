class InterestGroupSweeper < ActionController::Caching::Sweeper
  observe InterestGroup

  def after_create(interest_group)
    expire_cache_for(interest_group)
  end

  def after_update(interest_group)
    expire_cache_for(interest_group)
  end

  def after_destroy(interest_group)
    expire_cache_for(interest_group)
  end

  private

  def expire_cache_for(interest_group)
  end
end
